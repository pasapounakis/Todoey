//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Panos Lee Sapounakis on 03/05/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        loadCategories()

    }
    
    //MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        
            cell.textLabel?.text = category.name
        
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else {fatalError()}
            
            cell.backgroundColor = categoryColor
        
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        }
            
        return cell
            
    }
    
     //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
  
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category: Category) {
      
        do {
      
            try realm.write {
                realm.add(category)
            }
       
        } catch {
       
            print("Error saving categories \(error)")
      
        }
      
        tableView.reloadData()
    
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
                
        if let categoryForDeletion = self.categories?[indexPath.row] {

            do {

                try self.realm.write {

                    self.realm.delete(categoryForDeletion)

                }

            } catch {

                print("Error deleting category, \(error)")

            }

        }
        
    }
    
    //MARK: - Add new category button
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "Enter name of new category", preferredStyle: .alert)
        
        let addCategoryAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.backgroundColor = UIColor.randomFlat.hexValue()
            
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Name of new category"
            
            textField = alertTextField
            
        }
     
        alert.addAction(addCategoryAction)
        
        present(alert, animated: true, completion:  nil)
        
    }

}
