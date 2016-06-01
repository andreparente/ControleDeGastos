//
//  DAOCloudKit.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 6/1/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation
import CloudKit
import NotificationCenter

class DAOCloudKit {
    
    func saveUser(user: User) {

        let recordId = CKRecordID(recordName: "User " + user.name)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("Already exists user!!")
                
            }
                
            else {
                
                if(fetchedRecord == nil) {
                    
                    print("primeira vez que ta criando")
                    record.setObject(user.name, forKey: "name")
                    record.setObject(user.email, forKey: "email")
                    record.setObject(user.password, forKey: "password")
                    
                    
                    publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                        if (error != nil) {
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    //NS NOTIFICATION CENTER
    
    func fetchUserByEmail(email: String,password: String) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "User", predicate: predicate)
        print("passou pela criacao da query")
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {

                for result in results! {
                    if(result.valueForKey("email") as? String == email) {
                        if(result.valueForKey("password") as? String == password) {
                            
                            print("user existe!")
                            
                            //Inicializa o user Logado
                            userLogged = User(name: result.valueForKey("name") as! String, email: email, password: password)
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLogin", object: nil)
                            return;
                        }
                        else {
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorPassword", object: nil)
                        }
                    }
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorEmail", object: nil)
            }
        }
    }
    
}
