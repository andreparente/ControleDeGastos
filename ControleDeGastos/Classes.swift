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

public class Usuario {

    var email = String()
    var senha = String()
    var nome = String()
    var limiteMes = 0
    var cartoes = [Cartao]()
    var gastos = [Gasto]()
    var categoriasGastos = [String?]()

    init(){}
    
    init(nome: String,email: String,senha: String) {
        self.nome = nome
        self.email = email
        self.senha = senha
        self.categoriasGastos.append("Outros")
    }

    func addCategoriaGasto(categ: String) {
        self.categoriasGastos.append(categ)
    }

    func getCategoriasGastos() -> [String?] {
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
    
    func getCartaoIndex(nomeCartao: String) -> Int {
        for j in 0..<self.cartoes.count {
            if (self.cartoes[j].nome == nomeCartao) {
                return j
            }
        }
        return -1
    }

    func setLimiteMes(limite: Int) {
        self.limiteMes = limite
    }
    
    func getLimiteMes() -> Int {
        return self.limiteMes
    }
    
    //funçao que retorna o vetor de gastos de um determinado mês (de 01 a 12)
    func getGastosMês(mesAno: String) -> [Gasto?] {
        var gastosMes: [Gasto?] = []
        print("print getgastosMes era pra ser mes e ano só: ", mesAno)
        for gasto in self.gastos {
            if gasto.data.rangeOfString(mesAno) != nil {
                print("\(gasto.data)")
                gastosMes.append(gasto)
            }
        }
        return gastosMes
    }
}

public class Gasto {
    var nome = String()
    var valor = Int() // temporariamente para que o AIO funcione
    var data = String() // formato "yyyy-MM-dd-hh-mm-ss"
    //var foto: UIImage?
    var ehDinheiro = Bool()
    var categoria = String()
    var cartao: Cartao?

    // init para gasto em dinheiro
    init(nome: String, categoria: String, valor: Int, data: String) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = true
    }

    // init para gasto em cartao
    init(nome: String, categoria: String, valor: Int, data: String, cartao: Cartao) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = false
        self.cartao = cartao
    }
    /*
    func setFoto(foto: UIImage) {
        self.foto = foto
    }

    func getFoto() -> UIImage {
        return self.foto!
    }
    */
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
