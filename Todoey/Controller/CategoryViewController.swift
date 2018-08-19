//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Arkadipra De on 8/17/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Categories yet"
        
        return cell
    }
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var categoryText = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //let category = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = categoryText.text!
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
