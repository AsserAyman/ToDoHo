//
//  ViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/21/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //Array used to store the notes
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let itemArrayKey = "ToDoListArray"
    let ayhaga = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ayhaga.title = "ayhaga"
        itemArray.append(ayhaga)
        if let items = defaults.array(forKey: itemArrayKey) as? [Item]{
            itemArray = items
        }
    }

    
    //MARK - TableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    
 
    
    //MARK - TableView Delegate source methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Checking and uncheking the To-Do
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    //MARK - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newText = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
           
            //What will happen when user press add button
            let item = Item()
            item.title = newText.text!
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: self.itemArrayKey)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            newText = textField
        }
        present(alert, animated: true, completion: nil)
    }
}

