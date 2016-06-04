//
//  User.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 6/1/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation
import CloudKit


public var userLogged: User!
public var arrayUserRecords: Array<CKRecord> = []
public var users: [User] = []

public class User {
    
    var name: String!
    var email: String!
    var password: String!
    var categories: [String] = ["Outras"]
    var limiteMes: Double = 0
    var arrayGastos: [CKReference] = []
    public var gastos: [Gasto] = []
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func addCategoriaGasto(categ: String) {
        self.categories.append(categ)
    }
    
    func getCategoriasGastos() -> [String] {
        return self.categories
    }
    
    func addGasto(gasto: Gasto) {
        self.gastos.append(gasto)
    }
    
    func getGastos() -> [Gasto] {
        return gastos
    }
    
    /*func addCartao(cartao: Cartao) {
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
    }*/
    
    func setLimiteMes(limite: Double) {
        self.limiteMes = limite
    }
    
    func getLimiteMes() -> Double {
        return self.limiteMes
    }
  
    
    // -------------------------------------------- MUDAR ESSAS FUNCOES PARA CLOUDKIT-------------------------------
    
    /*

    func getGastosMes(mes: Int, ano: Int,user:User) -> [Gasto] {
        // gera o novo vetor
        var gastosMes: [Gasto] = []
        let recordId = CKRecordID(recordName: "Gasto " + user.name)
        let record = CKRecord(recordType: "Gasto", recordID: recordId)
        let dataatual=NSDate()
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "data", ascending: false)
        let query = CKQuery(recordType: "Gasto", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock{(record) in
        let gasto = Gasto()
        gasto.date = record["date"] as! String
        gasto.name = record["name"] as! String
        gasto.value = record["value"] as! String
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
      
            let data = Gasto.date.componentsSeparatedByString("-")
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

    */

    
}
