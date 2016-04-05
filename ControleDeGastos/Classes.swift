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
    
    // passando zero retorna os gastos de hoje
    func getGastosMes(mes: Int, ano: Int) -> [Gasto] {
        // gera o novo vetor
        var gastosMes: [Gasto] = []
        for gasto in self.gastos {
            let data = gasto.data.componentsSeparatedByString("-")
            // data == [ano, mes, dia]
            let mesGasto = Int(data[1])
            let anoGasto = Int(data[0])
            if (mesGasto == mes && ano == anoGasto) {
                gastosMes.append(gasto)
            }
        }
        return gastosMes
    }
    
    // passando zero retorna os gastos de hoje
    func getGastosUltimosDias(dias: Int) -> [Gasto] {
        // descobre ano, mes e dia atuais
        let hoje = NSDate()
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
        let mesAtual = components.month
        let anoAtual = components.year
        let diaAtual = components.day
        
        // gera o novo vetor
        var gastosUltimosDias: [Gasto] = []
        for gasto in self.gastos {
            let data = gasto.data.componentsSeparatedByString("-")
            // data == [ano, mes, dia]
            let dia = Int(data[2])
            let mes = Int(data[1])
            let ano = Int(data[0])
            if (mes == mesAtual && ano == anoAtual && dia >= (diaAtual - dias)) {
                gastosUltimosDias.append(gasto)
            }
        }
        return gastosUltimosDias
    }
    
    func getGastosHoje() -> [Gasto] {
        return getGastosUltimosDias(0)
    }
    
    // funcao retorna os gastos do ultimo mes
    // exemplo, se for chamada no dia 2016-03-14,
    // vai retornar os gastos de 03-01 a 03-14
    func getGastosUltimoMês() -> [Gasto] {
        // descobre ano e mes atuais
        let hoje = NSDate()
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
        let diaAtual = components.day
        
        // subtrai 1 pq os dias do mes nao comecam no zero
        return getGastosUltimosDias(diaAtual-1)
    }
}

public class Gasto {
    var nome = String()
    var valor = Double() // temporariamente para que o AIO funcione
    var data = String() // formato "yyyy-MM-dd-hh-mm-ss"
    //var foto: UIImage?
    var ehDinheiro = Bool()
    var categoria = String()
    var cartao: Cartao?

    // init para gasto em dinheiro
    init(nome: String, categoria: String, valor: Double, data: String) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = true
    }

    // init para gasto em cartao
    init(nome: String, categoria: String, valor: Double, data: String, cartao: Cartao) {
        self.nome = nome
        self.categoria = categoria
        self.valor = valor
        self.data = data
        self.ehDinheiro = false
        self.cartao = cartao
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
