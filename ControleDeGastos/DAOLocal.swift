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
    
    func salvarGasto(gasto: Gasto) {
        
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
    
    func loadGastos() -> [Gasto] {
        
        var gastosAux: [Gasto] = []
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Gasto")
        
        gastosGlobal.removeAll()
        //isso já deixa numa ordem crescente ou decrescente, pelo que to entendendo da parada...
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            gastosCoreData = results as! [NSManagedObject]
            
            //pra garantir que o gastosGlobal e o gastosCoreData estao na mesma ordem, que nem o cloudKit!
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                    categoria: gasto.valueForKey("category") as! String,
                    valor: gasto.valueForKey("value") as! Double,
                    data: gasto.valueForKey("date") as! NSDate))
            }
            
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        return gastosAux
    }
    
    func removeAtIndex(index: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        // 3
        moc.deleteObject(gastosCoreData[index])
        appDelegate.saveContext()
        
        // 4
        gastosCoreData.removeAtIndex(index)
    }
    
    func loadGastosEspecifico(fromDate: NSDate, toDate: NSDate) -> [Gasto] {
        
        var gastosAux: [Gasto] = []
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false

        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", fromDate, toDate)
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as? [NSManagedObject]
            
            //aqui teremos que botar na ordem o gastosGlobal ou o userLogged.gastos?? acho que na versao "offline"nao iremos ter User neh
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! NSDate))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        
        return gastosAux
    }
    
    func loadGastosMesEspecifico(month: String) -> [Gasto] {
        
        var gastosAux: [Gasto] = []

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false
        
        let fromDate = "2016-"+month+"-01"
        let toDate = "2016-"+month+"-31"
        request.predicate = NSPredicate(format: "(date >= %@) AND (date<= %@)", fromDate,toDate)
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as! [NSManagedObject]
            
            //aqui teremos que botar na ordem o gastosGlobal ou o userLogged.gastos?? acho que na versao "offline"nao iremos ter User neh
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! NSDate))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        return gastosAux
    }
    
    
    func filtrarPorData(fromDate: NSDate, toDate: NSDate) -> [Gasto] {
        
        var gastosAux: [Gasto] = []

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", fromDate, toDate)
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as? [NSManagedObject]
            
            //aqui teremos que botar na ordem o gastosGlobal ou o userLogged.gastos?? acho que na versao "offline"nao iremos ter User neh
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! NSDate))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        return gastosAux
    }
    
    func ordernar(ascending: Bool, value: Bool) -> [Gasto] {
         var gastosAux: [Gasto] = []
        print("entrou no ordenar")
        
        //----------------------------------------------PARA PEGAR O PRIMEIRO E ULTIMO DIA DO MES---------------------------------------------------------------------
        
        let calendar = NSCalendar.currentCalendar()
        let twoMonthsAgo = calendar.dateByAddingUnit(.Month, value: -2, toDate: NSDate(), options: [])
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let components = calendar.components([.Year, .Month], fromDate: NSDate())
        let startOfMonth = calendar.dateFromComponents(components)!
        print(dateFormatter.stringFromDate(startOfMonth))
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startOfMonth, options: [])!
        print(dateFormatter.stringFromDate(endOfMonth))
        
        // -------------------------------------------------------------------------------------------------------------------
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", twoMonthsAgo!, endOfMonth)
        
        if value {
            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: ascending)]
        } else {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: ascending)]
        }
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as? [NSManagedObject]
            
            //aqui teremos que botar na ordem o gastosGlobal ou o userLogged.gastos?? acho que na versao "offline"nao iremos ter User neh
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! NSDate))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        return gastosAux
    }
    
    func filtrarPorDataCategoriaPreço(fromDate: NSDate, toDate: NSDate, fromPrice: Double, toPrice: Double, category: String) -> [Gasto] {
        
        var gastosAux: [Gasto] = []

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var request = NSFetchRequest(entityName: "Gasto")
        request.returnsObjectsAsFaults = false
        
        print(fromDate)
        print(toDate)
        print(fromPrice)
        print(toPrice)
        if category == "Todas" {
            request.predicate = NSPredicate(format: "((date >= %@) AND (date <= %@)) AND ((value >= %lf) AND (value <= %lf))", fromDate, toDate, fromPrice, toPrice)
            //request.predicate = NSPredicate(format: "(value >= %lf) AND (value <= %lf)", fromPrice, toPrice)

        } else {
            request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (value >= %@) AND (value <= %@) AND (category == %@)", fromDate, toDate,fromPrice, toPrice,category)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let results = try managedContext.executeFetchRequest(request)
            gastosCoreData = results as? [NSManagedObject]
            
            gastosGlobal.removeAll()
            for gasto in gastosCoreData {
                gastosAux.append(
                    Gasto(nome: gasto.valueForKey("name") as! String,
                        categoria: gasto.valueForKey("category") as! String,
                        valor: gasto.valueForKey("value") as! Double,
                        data: gasto.valueForKey("date") as! NSDate))
            }
        } catch let error as NSError {
            print("Erro ao fetch Exercicios: \(error.localizedDescription), \(error.userInfo)")
        }
        return gastosAux
    }
}