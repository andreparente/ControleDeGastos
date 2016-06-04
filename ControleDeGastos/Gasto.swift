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


public class Gasto {
    var name : String?
    var value = Double()
    var date = String() // formato "yyyy-MM-dd-hh-mm-ss"
    //var ehDinheiro = Bool()
    var category = String()
   // var cartao: Cartao?
    
    // init para gasto em dinheiro
    init(nome: String, categoria: String, valor: Double, data: String) {
        self.name = nome
        self.category = categoria
        self.value = valor
        self.date = data
//        self.ehDinheiro = true
    }
    
    // init para gasto em cartao
    init(nome: String, categoria: String, valor: Double, data: String, cartao: Cartao) {
        self.name = nome
        self.category = categoria
        self.value = valor
        self.date = data
//        self.ehDinheiro = false
//        self.cartao = cartao
    }
    
}
