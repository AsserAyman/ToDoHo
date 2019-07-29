//
//  ViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/21/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let itemArrayKey = "ToDoListArray"
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textInSearchBar = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newText = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
     
            let item = Item(context: self.context)
            item.title = newText.text!
            item.done = false
            self.itemArray.append(item)
            self.saveItems()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            newText = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation
    func saveItems(){
        do{
           try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        do{
           try itemArray = context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
  
}
//MARK - Search Bar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        textInSearchBar = searchBar.text!
        searchFunc()
    }
    func searchFunc(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", textInSearchBar)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with : request)

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textInSearchBar = searchBar.text!
        if textInSearchBar == ""{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            searchFunc()
        }
    }
 
  
}
