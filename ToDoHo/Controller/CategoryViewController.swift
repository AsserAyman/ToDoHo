//
//  CategoryViewController.swift
//  ToDoHo
//
//  Created by Asser on 7/29/19.
//  Copyright © 2019 Asser. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //MARK: - Variables
    var categoryArray = [Category]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = self.categoryArray[indexPath.row]
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
            let newCategory = Category(context: ToDoListViewController.context)
            newCategory.name = text.text
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        do{
            try ToDoListViewController.context.save()
        }  catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            try categoryArray = ToDoListViewController.context.fetch(request)
        } catch {
            print(error)
        }
    }
}
