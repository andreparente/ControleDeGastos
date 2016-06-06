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
    
    func cloudAvailable()->(Bool)
    {
        if let token = NSFileManager.defaultManager().ubiquityIdentityToken{
            return true
        }
        else{
            return false
        }
    }
    func saveUser(user: User) {
        
        let recordId = CKRecordID(recordName: user.email)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("Already exists user!!")
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorRegister", object: nil)
                
            }
                
            else {
                
                if(fetchedRecord == nil) {
                    
                    print("primeira vez que ta criando")
                    record.setObject(user.name, forKey: "name")
                    record.setObject(user.email, forKey: "email")
                    record.setObject(user.password, forKey: "password")
                    record.setObject(user.categories, forKey: "categories")
                    
                    
                    publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                        if (error != nil) {
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    func addCategory(user: User) {
        
        let recordId = CKRecordID(recordName: user.email)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        var gastos = [CKRecordID]()
        for employeeReference in record.objectForKey("expenses") as! [CKReference] {
            gastos.append(employeeReference.recordID)
        }
        
        var fetchOperation = CKFetchRecordsOperation(recordIDs: gastos)
        fetchOperation.fetchRecordsCompletionBlock = {
            records, error in
            if error != nil {
                print("\(error)")
            } else {
                for (recordId, record) in records! {
                    print("\(record)")
                }
            }
        }
        
        
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(fetchOperation)
    }
    
        /*
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("Already exists user!!")
                //record["categories"] = nil
                record.setObject(user.categories, forKey: "categories")
                
                publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if (error != nil) {
                        print(error)
                    }
                })
                
                NSNotificationCenter.defaultCenter().postNotificationName("notificationCategoryAdded", object: nil)
                
            }
                
            else {
                
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorAddCategory", object: nil)
                
                
            }
        }
    }
    */
    func addGasto(gasto: Gasto, user: User) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        let myRecord = CKRecord(recordType: "Gasto")
        
        let reference = CKReference(recordID: CKRecordID(recordName: user.email!), action: .DeleteSelf)
        
        myRecord.setObject(gasto.name, forKey: "name")
        myRecord.setObject(gasto.date, forKey: "data")
        myRecord.setObject(gasto.category, forKey: "category")
        myRecord.setObject(gasto.value, forKey: "value")
        myRecord.setObject(reference, forKey: "user")
        
        publicDatabase.saveRecord(myRecord, completionHandler:
            ({returnRecord, error in
                if let err = error {
                    print(error)
                    //  NSNotificationCenter.defaultCenter().postNotificationName("notificationSaveError", object: nil)
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        // NSNotificationCenter.defaultCenter().postNotificationName("notificationSaveSuccess", object: nil)
                    }
                    
                }
            }))
        
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
    
    
    func changeLimit(user: User) {
        
        let recordId = CKRecordID(recordName: user.email)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("Already exists user!!")
                record.setObject(userLogged.limiteMes, forKey: "monthLimit")
                
                publicDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if (error != nil) {
                        print(error)
                    }
                })
            }
                
            else {
                print(error)
            }
        }
    }
    
    func fetchUser(user: User) {
        
        
        let recordId = CKRecordID(recordName: user.email)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        dispatch_async(dispatch_get_main_queue()) {
            
            publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
                
                if error == nil {
                    
                    print("Already exists user!!")
                    
                }
                    
                else {
                    print(error)
                }
            }
        }
    }
    
    //BUSCA OS GASTOS DE ACORDO COM A PK DO EMAIL DO USER LOGADO
    func fetchGastosFromUser(user: User) {
        
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Gasto", predicate: predicate)
        let userReference = CKReference(recordID: CKRecordID(recordName: user.email), action: .DeleteSelf)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                userLogged.gastos.removeAll()
                
                for result in results! {
                    if(result.valueForKey("user") as? CKReference  == userReference) {
                        
                        
                        userLogged.gastos.append(Gasto(nome: result.valueForKey("name") as! String, categoria: result.valueForKey("category") as! String, valor: result.valueForKey("value") as! Double, data: result.valueForKey("data") as! String))
                        print(result.valueForKey("user"))
                        print(result.valueForKey("name"))
                        
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
            }
        }
    }
}


