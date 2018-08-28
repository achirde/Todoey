//
//  ViewController.swift
//  Todoey
//
//  Created by Arkadipra De on 8/12/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeCellTableViewController   {

    let realm = try! Realm()
    var items : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: (selectedCategory?.color)!)
        
    }
    
    // MARK - Tableview Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title

            
            // Ternary Operator
            // Value = Condition ? If true : If False
            cell.accessoryType = item.done ? .checkmark : .none
            if let darkenPercentage : CGFloat = CGFloat(indexPath.row) / CGFloat((items?.count)!) {
                cell.backgroundColor = UIColor(hexString: (selectedCategory?.color)!)?.darken(byPercentage: darkenPercentage)
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            }
        }else {
            cell.textLabel?.text = "No items yet"
        }

        return cell
    }
    
    override func saveDataToDatabase(row: Int) {
        do{
            if let item = self.items?[row]{
                try self.realm.write{
                    self.realm.delete(item)
                }
            }else{
                print("Error in deleting Item")
            }
        }catch{
            print("Error in deleting item,\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var alertTextFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in

            // What will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertTextFieldValue.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error encoding item array, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            alertTextFieldValue = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    

        if let item = items?[indexPath.row]{
            
            do{
                try realm.write {
//                    realm.delete(item)
                   item.done = !item.done
                }
            }catch{
                print("Error in updating item, \(error)")
            }

        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()


    }
    
    // MARK - Model Manipulation Methods

    func loadItems(){

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

}


// MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)! {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}



