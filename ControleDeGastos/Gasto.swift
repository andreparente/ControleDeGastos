//
//  Gasto.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 6/2/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation
import CloudKit

public var arrayGastoRecords: Array<CKRecord> = []
public var gastos: [Gasto] = []

public class Gasto {
    var nome = String()
    var valor = Double() // temporariamente para que o AIO funcione
    var data = String() // formato "yyyy-MM-dd-hh-mm-ss"
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
