//
//  ViewController.swift
//  Todo
//
//  Created by pop on 5/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    var ItemArray = [Item]()
    let datafilePath = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datafilePath)
        loadItems()
    }
    
    // MARK - TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = ItemArray[indexPath.row]
        cell.textLabel?.text = item.name
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        //cell.accessoryType = item.done ? .checkmark : .none
        if ItemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    // MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //newItem[indexPath.row].done = !newItem[indexPath.row].done
        if ItemArray[indexPath.row].done == false{
            ItemArray[indexPath.row].done = true
        }else{
            ItemArray[indexPath.row].done = false
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - ADD Item
    
    
    @IBAction func AddBTNIPressed(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "add new Todo Item", message: "enter name", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in //closure
            let item = Item()
            item.name = textfield.text!
            self.ItemArray.append(item)
            self.saveItems()
        }
        alert.addTextField { (textfieldAlert) in
            textfieldAlert.placeholder = "add name"
            textfield = textfieldAlert
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.ItemArray)
            try data.write(to: self.datafilePath!)
        }catch{
            print("error encode")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: datafilePath!){
            let decoder = PropertyListDecoder()
            do{
                ItemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("error in decoder")
            }
        }
        
    }

}

