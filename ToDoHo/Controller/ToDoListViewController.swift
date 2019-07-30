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
    
    //MARK: - Variables
    var itemArray = [Item]()
    let itemArrayKey = "ToDoListArray"
    var selectedCategory  : Category? {
        didSet {
            loadItems()
        }
    }
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textInSearchBar = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
     
            let item = Item(context: ToDoListViewController.context)
            item.title = newText.text!
            item.done = false
            item.parentCategory = self.selectedCategory
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
           try ToDoListViewController.context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        do{
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            var compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
            if let passedPredicate = predicate {
                 compundPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [passedPredicate,categoryPredicate])
            }
            request.predicate = compundPredicate
           try itemArray = ToDoListViewController.context.fetch(request)
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
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", textInSearchBar)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with : request,predicate: predicate)

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
