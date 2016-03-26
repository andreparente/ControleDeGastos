//
//  DAOClasses.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import CoreData

class DAO {
    
    var managedContext: NSManagedObjectContext?
    
    internal func connectDAO() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        return true
    }
    
    // insere usuario na base
    // usar unicamente na tela de cadastro
    func saveUsuario(usuario: Usuario) -> Bool {
        //2
        let entity =  NSEntityDescription.entityForName("Usuario",
            inManagedObjectContext:managedContext!)
        
        let user = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        user.setValue("nometeste", forKey: "nome")
        
        //4
        do {
            try managedContext!.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return true
    }
    
    // salva os dados de um usuario que ja existe na base
    // usar quando o usuario logado for modificado
    // e antes de fechar o aplicativo
    func updateUsuario(usuario: Usuario) -> Bool {
        return true
    }
    
    // pega um usuario na base
    // usar na tela de login
    func getUsuario(email: String) -> Usuario {
        return Usuario(nome: "admin", email: "admin@admin", senha: "123")
    }
}