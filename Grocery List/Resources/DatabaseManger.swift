//
//  DatabaseManger.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import Foundation
import FirebaseDatabase
final class DatabaseManger{
    
    static let shared = DatabaseManger()
    private let database = Database.database().reference()
    
    
}

extension DatabaseManger{
    ///add user in online list
    func onlineUsers(uid:String , email: String ,completion: @escaping (Bool) -> Void){
        database.child("Online").child(uid).setValue(email)
        
    }
    /// count number of users on Online
    func countUserOnline(completion: @escaping (Result<String, Error>) -> Void){
        database.child("Online").observe(.value) { DataSnapshot in
            if DataSnapshot.exists(){
                completion(.success(DataSnapshot.childrenCount.description))
            }
            else{
                completion(.failure(errorDatabase.failedTofech))
            }
        }
    }
    
    /// read all user Online
    func getAllUsers(completion: @escaping (Result<[Users], Error>)-> Void){
        database.child("Online").observe( .value, with: {snapshot in
           guard let values = snapshot.value as? [String : String] else {
            completion(.failure(errorDatabase.failedTofech))
                return
            }
            
            var listofUsers = [Users]()
            for (key ,value) in values{
                guard let email = value as? String else {
                          return
                      }
                let list = Users(uid: key, email: email)
                listofUsers.append(list)
            }

            completion(.success(listofUsers))
        })
        
    }
    /// make the user off online when sign out
    func OffOnline(uid : String, completion: @escaping (Bool) -> Void){
        database.child("Online").child(uid).removeValue(completionBlock:  { error
               , DatabaseReference in
                 if let error = error{
                 print(error)
                completion(false)
                  }
                   else{
               print("Delete")
                completion(true)
             }
            
        })
    }

    ///create a new item in Database
    func CreateNewItem(Nameitem:String , emailUser :String , completion: @escaping (Bool) -> Void){

        let list = List(name: Nameitem, addedByUser: emailUser)
        
        let newItem = [
            "name" : list.name,
            "addedByUser": list.addedByUser
        ]
        
        database.child("grocery-list-items/\(Nameitem)").observeSingleEvent(of: .value) {[weak self] snapShot in
            
            if var arrayTasks = snapShot.value as? [String: Any]{
                if !arrayTasks.isEmpty{
                    self?.database.child("grocery-list-items/\(Nameitem)").setValue(arrayTasks){ error, reference in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }
                        print(reference)
                        completion(true)
                    }
                }
                
            }else{
           
                self?.database.child("grocery-list-items/\(Nameitem)").setValue(newItem){ error, reference in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                    print(reference)
                    completion(true)
                }
                
            }
            
        }
        
    }
    
    /// read item
    func getAllItems(completion: @escaping (Result<[List],Error>) -> Void){
        database.child("grocery-list-items").observe(.value) { snapShot in
            
            guard let values = snapShot.value as? [String: Any] else{
                return
            }
            
            var listofArray = [List]()
            for (key ,value) in values{
                guard let items = value as? [String:Any],
                      let name = items["name"] as? String,
                      let addedByUser = items["addedByUser"] as? String else {
                          return
                      }
                let list = List(name: name, addedByUser: addedByUser)
                listofArray.append(list)
            }

            completion(.success(listofArray))
          
      }
   }
    
    ///Update item in Datebase
    func UpdateItem(itemName : String , oldItem: String,email:String, completion: @escaping (Bool) -> Void){
        // NOTE
     // cuz can't update key that have array of list so then will delete old item
        // ref : https://stackoverflow.com/questions/39107274/is-it-possible-to-rename-a-key-in-the-firebase-realtime-database
        //And if you change the value only without the key, a problem may occur during deletion
        
        
        self.DelteItem(itemName: oldItem, completion: {
            success in
            if success{
                // and then create a new one
                self.CreateNewItem(Nameitem: itemName, emailUser: email, completion: {
                    success in
                    if success{
                        completion(true)
                    }
                    else{
                        print("can't create after delete")
                        completion(false)
                    }
                })
            }
            else{
                completion(false)
                print("can't delete")
            }
        })
    }
    /// delete item from database
    func DelteItem(itemName : String , completion: @escaping (Bool) -> Void){
        database.child("grocery-list-items").child(itemName).removeValue { error
            , DatabaseReference in
            if let error = error{
                print(error)
                completion(false)
            }
            else{
                print("Delete")
                completion(true)
            }
        }
       
    }
}


extension DatabaseManger {
    public enum errorDatabase : Error{
        case failedTofech
    }
}
