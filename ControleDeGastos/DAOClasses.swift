//
//  DAOClasses.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class DAO {
    
    internal func connectDAO() -> Bool {
        return true
    }
    
    // insere usuario na base
    // usar unicamente na tela de cadastro
    func saveUsuario(usuario: Usuario) -> Bool {
        return true
    }
    
    // salva os dados de um usuario que ja existe na base
    // usar quando o usuario logado for modificado
    // e antes de fechar o aplicativo
    func updateUsuario(usuario: Usuario){
    }
    
    // pega um usuario na base
    // usar na tela de login
    func getUsuario() -> Usuario {
    }
}