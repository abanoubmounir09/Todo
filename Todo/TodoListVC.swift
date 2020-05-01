//
//  ViewController.swift
//  Todo
//
//  Created by pop on 5/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    var arr:[String] = ["pop","non","hellen"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK - TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = arr[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    // MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - ADD Item
    
    
    @IBAction func AddBTNIPressed(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "add new Todo Item", message: "enter name", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            self.arr.append(textfield.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (textfieldAlert) in
            textfieldAlert.placeholder = "add name"
            textfield = textfieldAlert
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

