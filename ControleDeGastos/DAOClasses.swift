//
//  DAOClasses.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import CoreData

// colocar nessa variavel o usuario depois de loggar
// lembrar de conferir a senha
var usuarioLogado: Usuario?

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
        let conection = connectDAO()
        if(!conection) {
            return false
        }
        
        let entity =  NSEntityDescription.entityForName("Usuario",
            inManagedObjectContext:managedContext!)
        let newUser = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        newUser.setValue(usuario.nome, forKey: "nome")
        newUser.setValue(usuario.email, forKey: "email")
        newUser.setValue(usuario.senha, forKey: "senha")
        newUser.setValue(usuario.limiteMes, forKey: "limiteMes")

        // salva alteracao na base
        var didSave = false
        do {
            try managedContext!.save()
            didSave = true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return didSave
    }
    
    // salva os dados de um usuario que ja existe na base
    // usar quando o usuario logado for modificado
    // e antes de fechar o aplicativo
    func updateUsuario(usuario: Usuario) -> Bool {
        return true
    }
    
    // procura por um usuario na base
    // usar na tela de login
    // retorna um bool para sucesso e o proprio usuario encontrado
    // lembrar de conferir a senha antes de loggar
    func loadUsuario(email: String) -> (Bool, Usuario) {
        let nilUser = Usuario()
        let conection = connectDAO()
        if(!conection) {
            return (false, nilUser)
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Pessoa")
        
        // pega o array de usuarios na base
        var usuarios = [Usuario]()
        do {
            let results =
            try managedContext!.executeFetchRequest(fetchRequest)
            usuarios = (results as? [Usuario])!
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // busca o usuario
        for i in 0..<usuarios.count {
            if (usuarios[i].email == email) {
                return (true, usuarios[i])
            }
        }
        return (false, nilUser)
    }
}