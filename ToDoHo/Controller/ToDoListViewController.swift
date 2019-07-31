//
//  ViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/21/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {
    
    //MARK: - Variables
    var itemArray : Results<Item>?
    let realm = try! Realm()
    let itemArrayKey = "ToDoListArray"
    var selectedCategory  : Category? {
        didSet {
            loadItems()
        }
    }
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var textInSearchBar = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK - TableView Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Found"
        }
        return cell
    }
    
    
    
    
    //MARK - TableView Delegate source methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Checking and uncheking the To-Do
        if let item = itemArray?[indexPath.row]{
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    
    //MARK - Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newText = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    
                    try self.realm.write {
                        let item = Item()
                        item.title = newText.text!
                        currentCategory.items.append(item)
                    }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            newText = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation
    
    
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
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
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", textInSearchBar).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

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
