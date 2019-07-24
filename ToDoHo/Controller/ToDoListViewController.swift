//
//  ViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/21/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let itemArrayKey = "ToDoListArray"
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decode()
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
        encode()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newText = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let item = Item()
            item.title = newText.text!
            self.itemArray.append(item)
            self.encode()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            newText = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Encoding and Decoding Data
    func encode(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        }catch{
            print("Error")
        }
        tableView.reloadData()
    }
    
    func decode(){
        let decoder = PropertyListDecoder()
        do{
           let data = try Data(contentsOf: filePath!)
            itemArray = try decoder.decode([Item].self, from: data)

        }catch{
            print(error)
        }
    }
}

