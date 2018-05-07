//
//  ViewController.swift
//  Todoey
//
//  Created by Panayiotis Lee Sapounakis on 04/04/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        
        didSet{
            
            loadItems()
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.backgroundColor else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Setup
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist.")}

        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }

    //MARK:- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title

            if let color = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)) / 2) {
            
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
            }
            
            cell.accessoryType = item.done ? .checkmark : .none

        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //Mark:- TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                
                try realm.write {

                    item.done = !item.done

                }
    
            } catch {
                
                print("Error updating realm, \(error)")
                
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Mark:- Add new items section
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new thing", message: "What do you want to do?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()

                        currentCategory.items.append(newItem)
                        
                        self.realm.add(newItem)
                        
                    }
                    
                } catch {
                    
                    print("Error saving item to realm, \(error)")
                    
                }

            }
            
            self.tableView.reloadData()
                
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Eg. Start a business"
            
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
            
        present(alert, animated: true, completion: nil)
        
    }

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            
            do {
              
                try self.realm.write {
              
                    self.realm.delete(itemForDeletion)
               
                }
                
            } catch {
                
                print("Error deleting item, \(error)")
                    
            }
           
        }
            
            
    }
        
        
}



////MARK: - Search Bar Methods
extension ToDoViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
     
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()

            }

        }

    }

}



