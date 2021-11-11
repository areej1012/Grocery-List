//
//  LoginViewController.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
class LoginViewController: UIViewController {
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var Password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LogInUser(_ sender: UIButton) {
        if Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorlbl.text = "Please fill all fields"
           return
        }
        let email = Email.text!
        let passwordUser = Password.text!
        Auth.auth().signIn(withEmail: email, password: passwordUser) { AuthDataResult, error in
            if let error = error{
                self.errorlbl.text = error.localizedDescription
            }
            else{
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(AuthDataResult?.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.OnlineUser(uid: AuthDataResult?.user.uid, email: email)
                self.transitionToHome()
                
            }
        }
        
    }
    
    
    @IBAction func LoginWithFcabook(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: {
            result , error in
            if let error = error {
                        print("Failed to login: \(error.localizedDescription)")
                        return
                    }

            guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { AuthDataResult, Error in
                if let error = error{
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else if let user = AuthDataResult?.user{
                    UserDefaults.standard.set(user.email, forKey: "email")
                    UserDefaults.standard.set(AuthDataResult?.user.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    self.OnlineUser(uid: AuthDataResult?.user.uid, email: user.email!)
                    self.transitionToHome()
                    
                }
            }
    })
        }

    
    
    ///make the user Online
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
