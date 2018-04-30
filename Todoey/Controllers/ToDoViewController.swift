//
//  ViewController.swift
//  Todoey
//
//  Created by Panayiotis Lee Sapounakis on 04/04/2018.
//  Copyright © 2018 Dev Lee Apps. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    //MARK:- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItems()
        
    }
    
    //Mark:- TableView Delegate Methods
    
    
    
    //Mark:- Add new items section
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new thing", message: "What do you want to do?", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Eg. Start a business"
            
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
            
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
        
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        
        } catch {
        
            print(error)
       
        }
        
        tableView.reloadData()
        
    }


    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
            
            do {
            
                itemArray = try decoder.decode([Item].self, from: data)
            
            } catch {
            
                print(error)
            
            }
            
            tableView.reloadData()
            
        }

    }


}


    


