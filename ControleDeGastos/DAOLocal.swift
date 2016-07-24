//
//  DAOLocal.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 7/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public var gastosCoreData: [NSManagedObject]!

public class DAOLocal {
    
    func salvarDadosGasto(gasto: Gasto) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Gasto", inManagedObjectContext: managedContext)
        var gastoManage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        gastoManage.setValue(gasto.name, forKey: "name")
        gastoManage.setValue(gasto.category, forKey: "category")
        gastoManage.setValue(gasto.date, forKey: "date")
        gastoManage.setValue(gasto.value, forKey: "value")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Erro ao salvar Gasto no CoreData: \(error), \(error.userInfo)")
        }
    }
    
    func loadGastos() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Gasto")
        
        //isso já deixa numa ordem crescente ou decrescente, pelo que to entendendo da parada...
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            gastosCoreData = results as! [NSManagedObject]
            
            //pra garantir que o gastosGlobal e o gastosCoreData estao na mesma ordem, que nem o cloudKit!
            for gasto in gastosCoreData {
                gastosGlobal.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                    categoria: gasto.valueForKey("category") as! String,
                    valor: gasto.valueForKey("value") as! Double,
                    data: gasto.valueForKey("date") as! String))
            }
            
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    func loadGastosEspecifico(fromDate: String, toDate: String) {
        
        //a data ta em qual formato mesmo??
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    //    dateFormatter.timeZone = NSTimeZone(name: "GMT") // this line resolved me the issue of getting one day less than the selected date
        let startDate:NSDate = dateFormatter.dateFromString(fromDate)!
        let endDate:NSDate = dateFormatter.dateFromString(toDate)!
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as! [NSManagedObject]
            
            //aqui teremos que botar na ordem o gastosGlobal ou o userLogged.gastos?? acho que na versao "offline"nao iremos ter User neh
            for gasto in gastosCoreData {
                gastosGlobal.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! String))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        print(gastosCoreData.count)
    }
    
    func deleteGastoEspecifico(gasto: Gasto, index: Int) {
        
      
        // remove the deleted item from the model
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.deleteObject(gastosCoreData[index])
        gastosCoreData.removeAtIndex(index)
        do {
            try context.save()
        } catch _ {
        }
    }
}