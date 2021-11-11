//
//  RegisterViewController.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var Eamil: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
///Create a new user
    @IBAction func CreateNewUser(_ sender: UIButton) {
        // check the text feilds not empty
        if Eamil.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorlbl.text = "Please fill all fields"
           return
        }
        let email = Eamil.text!
        let passwordUser = Password.text!
    
        Auth.auth().createUser(withEmail: email, password: passwordUser, completion:  { result , error in
            if let error = error{
                self.errorlbl.text = "\(error.localizedDescription)"
                print(error.localizedDescription)
            }
            else{
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set( result?.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.OnlineUser(uid: result?.user.uid, email: email)
                self.transitionToHome()
                
            }
            }
        )
        
    }
    func OnlineUser(uid :String?, email:String){
        guard let newUid = uid  else {
            return
        }
        
        DatabaseManger.shared.onlineUsers(uid: newUid, email: email, completion: {
            succ in
            if succ{
                print("OnlineUser")
            }
        })
    }
    
    func transitionToHome() {
        let vc = self.storyboard?.instantiateViewController(identifier: "NavList") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
