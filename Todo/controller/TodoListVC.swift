//
//  ViewController.swift
//  Todo
//
//  Created by pop on 5/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    var ItemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        return ItemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = ItemArray[indexPath.row]
        cell.textLabel?.text = item.title
        if ItemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    // MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Delete
//        context.delete( ItemArray[indexPath.row])
//        ItemArray.remove(at: indexPath.row)
        ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - ADD Item
    @IBAction func AddBTNIPressed(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "add new Todo Item", message: "enter name", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in //closure
            let Newitem = Item(context: self.context)
            Newitem.title = textfield.text!
            Newitem.done = false
            Newitem.parentCategory = self.selectedCAtegory
            self.ItemArray.append(Newitem)
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
        do{
            try context.save()
        }catch{
            print("error saving context\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predecit:NSPredicate? = nil){
        let CategoryPredecit = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCAtegory?.name!)!)
        if let additionalPredicate = predecit{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CategoryPredecit,additionalPredicate])
        }else{
              request.predicate = CategoryPredecit
        }
        do{
          ItemArray = try context.fetch(request)
        }catch{
            print("error fetching context\(error)")
        }
        tableView.reloadData()
    }

}
//MARK: - Serach Bar Methods
extension TodoListVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0{
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request,predecit: predicate)
        }else{
             loadItems()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            //MARK: - retrieve the window as first look without keyboard or search result
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else if searchBar.text?.count != 0{
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request,predecit: predicate)
        }
    }
}


