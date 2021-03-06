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
public var arrayGastoRecords: Array<CKRecord> = []
class DAOCloudKit {
    
    func cloudAvailable()->(Bool)
    {
        if NSFileManager.defaultManager().ubiquityIdentityToken != nil{
            return true
        }
        else{
            return false
        }
    }
    
    
    // ------------------------------ FUNCAO PARA PEGAR ID DO USER ---------------------------
    
    func getId(complete: (instance: CKRecordID?, error: NSError?) -> ()) {
        let container = CKContainer.defaultContainer()
        container.fetchUserRecordIDWithCompletionHandler() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(instance: nil, error: error)
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorGetId", object: nil)
            } else {
                print("fetched ID \(recordID?.recordName)")
                complete(instance: recordID, error: nil)
                
                
               // NSNotificationCenter.defaultCenter().postNotificationName("notificationSucessGetId", object: nil)
            }
        }
    }
    
    // ------------------------------ END OF FUNCTION -------------------------------------
    
    
    
    //------------------------------------ SAVE FUNCTIONS ------------------------------
    
    
    func saveUser(user: User) {
        
        let recordId = CKRecordID(recordName: user.cloudId)
        let record = CKRecord(recordType: "User", recordID: recordId)
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        privateDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("Already exists user!!")
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorRegister", object: nil)
                
            }
                
            else {
                
                if(fetchedRecord == nil) {
                    
                    print("primeira vez que ta criando")
                    
                    record.setObject(user.cloudId, forKey: "cloudId")
                    
                    record.setObject(user.categories, forKey: "categories")
                    
                    
                    privateDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
                        if (error != nil) {
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    func addCategory(user: User) {
        
        let recordId = CKRecordID(recordName: user.cloudId)
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        privateDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                fetchedRecord!.setObject(user.categories, forKey: "categories")
                
                privateDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
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
        let privateDatabase = container.privateCloudDatabase
        
        let myRecord = CKRecord(recordType: "Gasto")
        let recordId = CKRecordID(recordName: user.cloudId)
        
        myRecord.setObject(gasto.name, forKey: "name")
        myRecord.setObject(gasto.date, forKey: "dataNova")
        myRecord.setObject(gasto.category, forKey: "category")
        myRecord.setObject(gasto.value, forKey: "value")
        let gastoReference = CKReference(recordID: myRecord.recordID, action: .None)
        
        print("---------------------- Referencia do gasto: ", gastoReference)
        user.arrayGastos.append(gastoReference)
        
        
        privateDatabase.saveRecord(myRecord, completionHandler:
            ({returnRecord, error in
                if error != nil {
                    print(error)
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationSaveError", object: nil)
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationSaveSuccess", object: nil)
                    }
                    
                }
            }))
        
        
        container.privateCloudDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                
                print("---------------------- Referencia dos gastos: ", user.arrayGastos)
                fetchedRecord!.setObject(user.arrayGastos, forKey: "gastos")
                
                container.privateCloudDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
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
    
    
    
    //------------------------------------ END OF SAVE FUNCTIONS ------------------------------
    
    
    
    //------------------------------------ DELETE FUNCTIONS ------------------------------
    
    
    func deleteGasto(gastoToDelete: CKReference, user: User, index: Int) {
        
        let userRecordId = CKRecordID(recordName: user.cloudId)
        
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        privateDatabase.deleteRecordWithID(gastoToDelete.recordID,completionHandler:
            ({returnRecord, error in
                if error != nil {
                    print(error)
                    NSNotificationCenter.defaultCenter().postNotificationName("notificationDeleteError", object: nil)
                    
                }
            }))
        
        
        user.arrayGastos.removeAtIndex(index)
        
        
        container.privateCloudDatabase.fetchRecordWithID(userRecordId) { (fetchedRecord,error) in
            
            print(fetchedRecord)
            
            if error == nil {
                
                print("Already exists user!!")
                print("---------------------- Referencia dos gastos: ", user.arrayGastos)
                fetchedRecord!.setObject(user.arrayGastos, forKey: "gastos")
                
                container.privateCloudDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
                    if (error != nil) {
                        print(error)
                        
                        
                    }
                })
            }
        }
    }
    
    
    //------------------------------------ END OF DELETE FUNCTIONS ------------------------------
    
    
    //------------------------------------ FETCH FUNCTIONS ------------------------------
    
    
    func fetchCategoriesForUser(user: User) {
        
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorInternet", object: nil)
            }
            else {
                
                for result in results! {
                    if(result.valueForKey("cloudId") as? String == user.cloudId) {
                        
                        
                        //Inicializa o user Logado
                        userLogged.categories.removeAll()
                        for categ in result.valueForKey("categories") as! [String]
                        {
                            userLogged.categories.append(categ)
                        }
                        return
                    }
                    else {
                    }
                }
            }
        }
    }
/*
    func fetchUserByEmail(email: String!,password: String!) {
        
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorInternet", object: nil)
            }
            else {
                
                for result in results! {
                    if(result.valueForKey("email") as? String == email) {
                        
                        print("user existe!")
                        if (result.valueForKey("password") as? String == password)
                        {
                            
                            //Inicializa o user Logado
                            userLogged = User(name: result.valueForKey("name") as! String, email: email!, password: password!)
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLogin", object: nil)
                            return
                        }
                        else {
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorPassword", object: nil)
                            return
                        }
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorEmail", object: nil)
            }
        }
    }
    
    func fetchUserOnlyMail(email: String!) {
        
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                
                for result in results! {
                    if(result.valueForKey("email") as? String == email) {
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationFailCadastro", object: nil)
                        return
                    }
                    
                }
                NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessCadastro", object: nil)
                return
            }
        }
        
    }
    */
    //BUSCA OS GASTOS DE ACORDO COM A PK DO EMAIL DO USER LOGADO
    func fetchGastosFromUser(user: User) {
        
        let recordId = CKRecordID(recordName: user.cloudId)
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        
        var gastosRecordIds = [CKRecordID]()
        
        privateDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            // print(fetchedRecord)
            
            if error == nil {
                
                if let teste = fetchedRecord!.objectForKey("gastos") {
                    print("quantidade de gastos registrados: ", (teste as! [CKRecordValue]).count)
                    
                    
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
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorInternet", object: nil)
                            
                        } else {
                            
                            userLogged.gastos.removeAll()
                            userLogged.arrayGastos.removeAll()
                            
                            for (_, result) in records! {
                                
                                userLogged.arrayGastos.append(CKReference(recordID: result.recordID, action: .None))
                                userLogged.gastos.append(Gasto(nome: result.valueForKey("name") as! String, categoria: result.valueForKey("category") as! String, valor: result.valueForKey("value") as! Double, data: result.valueForKey("dataNova") as! NSDate))
                            }
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
                            
                            
                        }
                    }
                    
                    CKContainer.defaultContainer().privateCloudDatabase.addOperation(fetchOperation)
                }
                    
                else {
                    
                    if userLogged.gastos.count == 0
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
                    }
                    else{
                        NSNotificationCenter.defaultCenter().postNotificationName("notificationErrorLoadUser", object: nil)
                        
                    }
                    
                }
            }
            else {
                if userLogged.gastos.count == 0
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("notificationSuccessLoadUser", object: nil)
                }
                
                print(error)
            }
        }
    }
    
    //------------------------------------ END OF FETCH FUNCTIONS ------------------------------
    
    
    //------------------------------------ UPDATE/CHANGE FUNCTIONS ------------------------------
    
    
    
    func changeLimit(user: User) {
        
        let recordId = CKRecordID(recordName: user.cloudId)
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        privateDatabase.fetchRecordWithID(recordId) { (fetchedRecord,error) in
            
            if error == nil {
                
                print("MUDANDO O LIMITE POR MES DE UM USUARIO EXISTENTE")
                fetchedRecord!.setObject(userLogged.limiteMes, forKey: "monthLimit")
                
                privateDatabase.saveRecord(fetchedRecord!, completionHandler: { (record, error) -> Void in
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
    
    //------------------------------------ END OF UPDATE/CHANGE FUNCTIONS ------------------------------
    
}


