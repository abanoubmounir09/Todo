//
//  CategoryVC.swift
//  Todo
//
//  Created by pop on 5/4/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCAtegory()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel!.text = categoryArray?[indexPath.row].name ?? "No Categories Add"
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? TodoListVC
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC?.selectedCAtegory = categoryArray?[indexpath.row]
        }
    }

    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let controller = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(with: newCategory)
        }
        controller.addTextField { (textfieldAlert) in
            textfieldAlert.placeholder = "enter category name"
            textField = textfieldAlert
        }
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - SAVE CATEGORY
    func saveCategory(with category:Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    // MARK: - load CATEGORY
    func loadCAtegory(){
        categoryArray = try realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
