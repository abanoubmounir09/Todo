//
//  ViewController.swift
//  Todo
//
//  Created by pop on 5/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListVC: UITableViewController {
    var ItemArray:Results<Item>?
    let realm = try! Realm()
    var selectedCAtegory : Category?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = ItemArray?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "no items"
        if ItemArray?[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    // MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let item = ItemArray?[indexPath.row]{
            do{
                try realm.write{
                    //MARK: - delete object from realm
//                     realm.delete(item)
                    item.done = !item.done
                }
            }catch{print("error in updating\(error)")}
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - ADD Item
    @IBAction func AddBTNIPressed(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "add new Todo Item", message: "enter name", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in //closure
            if let currentCategory = self.selectedCAtegory{
                do{
                    try self.realm.write{
                        let Newitem = Item()
                        Newitem.title = textfield.text!
                        Newitem.done = false
                        currentCategory.items.append(Newitem)
                    }
                }catch{print(error)}
            }
           self.tableView.reloadData()
        }
        alert.addTextField { (textfieldAlert) in
            textfieldAlert.placeholder = "add name"
            textfield = textfieldAlert
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems(){
      ItemArray = selectedCAtegory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}
//MARK: - Serach Bar Methods
extension TodoListVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ItemArray = ItemArray?.filter("title CONTAINS[cd] %@", searchBar.text! ).sorted(byKeyPath: "title", ascending: true	)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            //MARK: - retrieve the window as first look without keyboard or search result
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
    }
}


}
