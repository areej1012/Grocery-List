//
//  Extension.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import Foundation
import  UIKit

extension GroceryList: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroceryListTableViewCell
        cell.nameitem.text = list[indexPath.row].name
        cell.nameEmail.text = list[indexPath.row].addedByUser
       return cell
    }
    
    //edit the item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let editItem = list[indexPath.row].name
       alertUpdate(oldItem: editItem)
    }
    // for delete the item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeItem(item: list[indexPath.row].name)
           tableView.reloadData()
       
    }
    
    func removeItem(item:String) {
        DatabaseManger.shared.DelteItem(itemName: item, completion: {
            succes in
            if succes{
                print("remove")
            }
            else{
                print("not ")
            }
        })
    }
    func alertUpdate(oldItem : String){
        let alert = UIAlertController(title: "Grocery item", message: "Update a new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            text in
            text.placeholder = "milk"
        })
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak self] (_) in
            let newItem = alert.textFields![0].text
            self!.EditItem(UpdateItem: newItem, oldItem: oldItem)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func EditItem(UpdateItem : String?, oldItem: String){
        guard let email = UserDefaults.standard.string(forKey: "email") , let newitem = UpdateItem else {
            return
        }
        DatabaseManger.shared.UpdateItem(itemName: newitem, oldItem: oldItem, email: email, completion: {
            succes in
            if succes{
                print("sec")
            }
            else{
                print("feild")
            }
        })
    }
    
}
