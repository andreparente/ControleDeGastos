//
//  DAOClasses.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class DAO {
    
    func connectCoreData() -> Bool {
    //implementar funcao de acesso ao CoreData
        return true
        
    }
}
class DAOUsuario {
    
    func getUsuario(usuario: Usuario) -> Usuario {
        //implementar funçao buscando do CoreData
        return usuario
    }
    
    func setUsuario(usuario: Usuario){
        //implementar funcao inserindo no CoreData
    }
    
    func getArrayGastos(usuario: Usuario) -> [Gasto] {
        //implementar funçao que carrega os gastos do usuario
        return usuario.gasto!
    }
    
    func addGasto(usuario: Usuario) -> Bool {
        //adicionar gasto ao DAO
        return true
    }
}