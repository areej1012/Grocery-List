//
//  UsersTableViewController.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import FirebaseAuth
class UsersTableViewController: UITableViewController {
    var user = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        read()
    }
    
    func read(){
        DatabaseManger.shared.getAllUsers(completion: {
            result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let users):
                DispatchQueue.main.async {
                    self.user = users
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return user.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user[indexPath.row].email

        return cell
    }
    ///sign out the current user
    @IBAction func SignOut(_ sender: UIBarButtonItem) {
        
        do{
        try Auth.auth().signOut()
            self.offOnlineUser(uid:  UserDefaults.standard.string(forKey: "uid") )
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.synchronize()
            self.transitionToLogIn()
        }catch{
            print(error.localizedDescription)
        }
    }
    func transitionToLogIn() {
        let vc = self.storyboard?.instantiateViewController(identifier: "nav") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    
    }
    
    func offOnlineUser(uid:String?){
        guard let UID = uid else {
            return
        }
        DatabaseManger.shared.OffOnline(uid: UID, completion: {
            succes in
            if succes{
                print("off onilne")
            }
            else{
                print("error off online")
            }
        })
    }
  
}
