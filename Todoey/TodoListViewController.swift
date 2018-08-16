//
//  ViewController.swift
//  Todoey
//
//  Created by Arkadipra De on 8/12/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [ToDoModel]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ToDoModel()
        item1.title = "Find Mike"
        itemArray.append(item1)
        
        let item2 = ToDoModel()
        item2.title = "Buy Eggos"
        itemArray.append(item2)
        
        let item3 = ToDoModel()
        item3.title = "Destroy Demogorgon"
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [ToDoModel] {
            itemArray = items
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK - Tableview Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var alertTextFieldValue = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in

            // What will happen once the user clicks the Add Item button on our UIAlert
            let item = ToDoModel()
            item.title = alertTextFieldValue.text!
            self.itemArray.append(item)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.defaults.set(self.itemArray, forKey: "TodoListArray")

    }

}

