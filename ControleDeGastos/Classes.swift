//
//  Classes.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class Gasto {
    
    var nome: String?
    var valor: Double?
    var data: String?
    var foto: UIImage?
    var ehDinheiro: Bool = true
    
    init(nome: String, valor: Double, data: String) {
        
        self.nome=nome
        self.valor=valor
        self.data=data
        
    }
    
}

class Usuario {
    
    var email: String?
    var senha: String?
    var nome: String?
    var limiteMes: Double?
    var gasto: [Gasto]?
    
    init(nome: String,email: String,senha: String,limiteMes: Double,gastos: [Gasto]) {
        self.nome = nome
        self.email = email
        self.senha = senha
        self.limiteMes = limiteMes
        self.gasto = gastos
    }
    
}

class Cartao {
    
    var nome: String?
    var limite: Double?
    var cor: UIColor?
    
    init(nome:String, limite:Double,cor: UIColor){
        self.nome = nome
        self.limite = limite
        self.cor = cor
        
    }
    
}

class categoria {
    
    var nome: String?
    
    init(nomeCat: String) {
        self.nome = nomeCat
        
    }
    
}