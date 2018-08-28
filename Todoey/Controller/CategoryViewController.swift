//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Arkadipra De on 8/17/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryViewController: SwipeCellTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none    
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Categories yet"
        if let cellBackgroundColor = UIColor(hexString:(category?.color)!){
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        }
        
        return cell
    }
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var categoryText = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //let category = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = categoryText.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            //self.categoryArray.append(newCategory)
            
            self.saveCategory(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a Category"
            categoryText = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
 
    }
    
    
    override func saveDataToDatabase(row: Int) {
        do{
            if let category = self.categories?[row]{
                try self.realm.write{
                    self.realm.delete(category)
                }
            }else{
                print("Error in deleting Category")
            }
        }catch{
            print("Error in deleting item,\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    // MARK : Add Custom Functions
    
    func saveCategory(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("Error in saving Category Data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        
    }

}

