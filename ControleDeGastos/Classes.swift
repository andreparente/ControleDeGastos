//
//  Classes.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

public let screenSize = UIScreen.mainScreen().bounds

class Usuario {

    var email: String
    var senha: String
    var nome: String
    var limiteMes: Double
    var cartoes = [Cartao]()
    var gastos = [Gasto]()
    var categoriasGastos = [String]()

    init(nome: String,email: String,senha: String) {
        self.nome = nome
        self.email = email
        self.senha = senha
        self.categoriasGastos.append("Outros")
    }

    func addCategoriaGasto(categ: String) {
        self.categoriasGastos.append(categ)
    }

    func getCategoriasGastos() -> [String] {
        return self.categoriasGastos
    }

    func addGasto(gasto: Gasto) {
        self.gastos.append(gasto)
    }

    func getGastos() -> [Gasto] {
        return self.gastos
    }

    func addCartao(cartao: Cartao) {
        self.cartoes.append(cartao)
    }

    func getCartoes() -> [Cartao] {
        return self.cartoes
    }

    func setLimiteMes(limite: Double) {
        self.limiteMes = limite
    }

    func getLimiteMes() -> Double {
        return self.limiteMes
    }
}

class Gasto {
    
    var nome: String
    var valor: Double
    var data: NSDate
    var foto: UIImage?
    var ehDinheiro: Bool
    var categoria: String!
    var cartao: Cartao

    init(nome: String, categoria: String, valor: Double, data: NSDate) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = true
    }

    init(nome: String, categoria: String, valor: Double, data: NSDate, cartao: Cartao) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = false
        self.cartao = cartao
    }

    func setFoto(foto: UIImage) {
        self.foto = foto
    }

    func getFoto() -> UIImage {
        return self.foto
    }
}

class Cartao {
    
    var nome: String
    var limite: Double
    var cor: UIColor

    init(nome:String, limite:Double, cor: UIColor){
        self.nome = nome
        self.limite = limite
        self.cor = cor
    }

    func setLimite(limite: Double) {
        self.limite = limite
    }

    func getLimite() -> Double {
        return self.limite
    }
}
