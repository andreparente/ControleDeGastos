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
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                fetchedRecord!.setObject(user.categories, forKey: "categories")
                
                publicDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
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
    
    func addGastoToUser(gast: Gasto, user: User) {
        
        let recordId = CKRecordID(recordName: user.email)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                fetchedRecord!.setObject(user.categories, forKey: "categories")
                
                publicDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
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
    
    func addGasto(gasto: Gasto, user: User) {
        
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        let myRecord = CKRecord(recordType: "Gasto")
        let recordId = CKRecordID(recordName: user.email)
        
        myRecord.setObject(gasto.name, forKey: "name")
        myRecord.setObject(gasto.date, forKey: "data")
        myRecord.setObject(gasto.category, forKey: "category")
        myRecord.setObject(gasto.value, forKey: "value")
        let gastoReference = CKReference(recordID: myRecord.recordID, action: .DeleteSelf)
        
        print("---------------------- Referencia do gasto: ", gastoReference)
        user.arrayGastos.append(gastoReference)
        
        
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
        
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                print("---------------------- Referencia dos gastos: ", user.arrayGastos)
                fetchedRecord!.setObject(user.arrayGastos, forKey: "gastos")
                
                publicDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
                    if (error != nil) {
                        print(error)
                    }
                })
                
                //  NSNotificationCenter.defaultCenter().postNotificationName("notificationCategoryAdded", object: nil)
                
            }
                
            else {
                
                //    NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorAddCategory", object: nil)
                
                
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
                        
                        print("user existe!")
                        
                        //Inicializa o user Logado
                        userLogged = User(name: result.valueForKey("name") as! String, email: email, password: password)
                        userLogged.categories.removeAll()
                        for categ in result.valueForKey("categories") as! [String]
                        {
                            userLogged.categories.append(categ)
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLogin", object: nil)
                        return;
                    }
                    else {
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorPassword", object: nil)
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
                
                print("MUDANDO O LIMITE POR MES DE UM USUARIO EXISTENTE")
                fetchedRecord!.setObject(userLogged.limiteMes, forKey: "monthLimit")
                
                publicDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
                    if (error != nil) {
                        print(error)
                        let alert=UIAlertController(title:"Erro", message: "Nāo foi possivel alterar seu  limite", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                        SettingsViewController().presentViewController(alert,animated: true, completion: nil)
                    }
                })
            }
                
            else {
                print(error)
            }
        }
    }
    
    
    //BUSCA OS GASTOS DE ACORDO COM A PK DO EMAIL DO USER LOGADO
    func fetchGastosFromUser(user: User) {
        
        let recordId = CKRecordID(recordName: user.email)
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        
        var gastosRecordIds = [CKRecordID]()
        
        publicDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            // print(fetchedRecord)
            
            if error == nil {
                print(fetchedRecord!.objectForKey("gastos"))
                if let teste = fetchedRecord!.objectForKey("gastos") {
                    print("quantidade de gastos registrados: ", (fetchedRecord!.objectForKey("gastos") as! [CKRecordValue]).count)
                    
                    print(fetchedRecord?.objectForKey("monthLimit"))
                    
                    if let limit = fetchedRecord?.objectForKey("monthLimit") {
                        
                        userLogged.limiteMes = limit as! Double
                    }
                    else {
                        
                        userLogged.limiteMes = 0
                    }
                    
                    for gastoReference in fetchedRecord!.objectForKey("gastos") as! [CKReference] {
                        gastosRecordIds.append(gastoReference.recordID)
                    }
                    
                    let fetchOperation = CKFetchRecordsOperation(recordIDs: gastosRecordIds)
                    fetchOperation.fetchRecordsCompletionBlock = {
                        records, error in
                        if error != nil {
                            print(error)
                        } else {
                            
                            
                            for (_, result) in records! {
                                userLogged.arrayGastos.append(CKReference(recordID: result.recordID, action: .None))
                                userLogged.gastos.append(Gasto(nome: result.valueForKey("name") as! String, categoria: result.valueForKey("category") as! String, valor: result.valueForKey("value") as! Double, data: result.valueForKey("data") as! String))
                            }
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
                            
                            
                        }
                    }
                    CKContainer.defaultContainer().publicCloudDatabase.addOperation(fetchOperation)
                }
                    
                else {
                    NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
                    
                }
                
            }
            else {
                print(error)
            }
        }
    }
}


