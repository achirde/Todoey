//
//  SwipeCellTableViewController.swift
//  Todoey
//
//  Created by Arkadipra De on 8/20/18.
//  Copyright © 2018 Achirangshu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
//        let category = categories?[indexPath.row]
//        cell.textLabel?.text = category?.name ?? "No Categories yet"
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            do{
//                if let category = self.categories?[indexPath.row]{
//                    try self.realm.write{
//                        self.realm.delete(category)
//                    }
//                }else{
//                    print("Error in deleting Category")
//                }
//            }catch{
//                print("Error in deleting item,\(error)")
//            }
            
            self.saveDataToDatabase(row: indexPath.row)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]

    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    func saveDataToDatabase(row: Int){
        
    }

}
