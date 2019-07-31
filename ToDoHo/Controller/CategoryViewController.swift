//
//  CategoryViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/29/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //MARK: - Variables
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = self.categoryArray?[indexPath.row]
        }
    }
    //MARK: - Adding New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showAddCategoryAlert()
    }
    
    func showAddCategoryAlert(){
        let alert = UIAlertController(title: "AddCategory", message: "", preferredStyle: .alert)
        var text = UITextField()
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder  = "Create new Category"
            text = textField
        })
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newCategory = Category()
            newCategory.name = text.text!
            self.saveCategories(category: newCategory)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }  catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}
