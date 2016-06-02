//
//  Classes.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import CoreData

public let screenSize = UIScreen.mainScreen().bounds

public let corVerde = UIColor(red:0, green:0.60, blue:0.89, alpha:1.0)
public let corAzul = UIColor(red:(51.0/255), green:(204.0/255), blue:1, alpha:1.0)
public let corAmarela = UIColor(red:(204.0/255),green:(204.0/255),blue:0,alpha: 1.0)
public let corVermelha = UIColor(red:1,green:0,blue:0,alpha:1.0)
public var eamarela = false
public var evermelha = false

//public let corVerde = UIColor(red:0.50, green:0.71, blue:0.52, alpha:1.0)

public class Usuario {

    var email = String()
    var senha = String()
    var nome = String()
    var limiteMes = 0
    var cartoes = [Cartao]()
    var gastos = [Gasto]()
    var categoriasGastos = [String]()

    init(){}
    
    init(nome: String,email: String,senha: String) {
        self.nome = nome
        self.email = email
        self.senha = senha
    }

        
  }


public class Cartao {
    
    var nome = String()
    var limite = Int()
    var cor: Int

    init(nome:String, limite:Int, cor: Int){
        self.nome = nome
        self.limite = limite
        self.cor = cor
    }

    func setLimite(limite: Int) {
        self.limite = limite
    }

    func getLimite() -> Int {
        return self.limite
    }
}
