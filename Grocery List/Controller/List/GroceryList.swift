//
//  ViewController.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import FirebaseAuth
class GroceryList: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var list = [List]()
   
    @IBOutlet weak var CountUserButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        verification()
        tableview.delegate = self
        tableview.dataSource = self
      
    }
    override func viewDidAppear(_ animated: Bool) {
        read()
        DatabaseManger.shared.countUserOnline { results in
            switch results{
            case.failure(let error):
                print(error)
            case .success(let number):
                self.CountUserButton.title = number
            }
        }
    }
    /// check if the user is login before
    func verification(){
        if Auth.auth().currentUser == nil{
            let desCV = storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
                desCV.modalPresentationStyle = .fullScreen
                present(desCV, animated: false, completion: nil)
        }
      
    }
    ///add a new item in the list
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Grocery item", message: "add a new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            text in
            text.placeholder = "milk"
        })
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak self] (_) in
            let newItem = alert.textFields![0].text
            self!.SaveNewItemInDB(item: newItem!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    /// save a new item in DateBase
    func SaveNewItemInDB(item: String){
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        
        DatabaseManger.shared.CreateNewItem(Nameitem: item, emailUser: email,  completion: {
            s in
            if s{
                print("secess")
            }
            else{
                print("feild")
            }
        } )
        
   }
    func read(){
        print("here")
     
        
        DatabaseManger.shared.getAllItems(completion: { result in
          switch  result{
          case .failure(let erro):
            print(erro)
          case .success(let newList):
            DispatchQueue.main.async {
                self.list = newList
                self.tableview.reloadData()
            }
            }
        })
 
    }
    
    
}

