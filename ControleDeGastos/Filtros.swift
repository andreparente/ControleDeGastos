//
//  Filtros.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 04/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation

// filtra o vetor de gastos pelo intervalo de valores
public func filtraValor(min: Double, max: Double, gastos: [Gasto]) -> [Gasto] {
    // gera o novo vetor
    var gastosFiltrados: [Gasto] = []
    for gasto in gastos {
        let valor = gasto.valor
        if (valor >= min && valor <= max) {
            gastosFiltrados.append(gasto)
        }
    }
    return gastosFiltrados
}

// filtra o vetor de gastos pelo valor minimo
public func filtraValorMin(min: Double, gastos: [Gasto]) -> [Gasto] {
    // gera o novo vetor
    var gastosFiltrados: [Gasto] = []
    for gasto in gastos {
        let valor = gasto.valor
        if (valor >= min) {
            gastosFiltrados.append(gasto)
        }
    }
    return gastosFiltrados
}

// filtra o vetor de gastos pelo valor maximo
public func filtraValorMax(max: Double, gastos: [Gasto]) -> [Gasto] {
    // gera o novo vetor
    var gastosFiltrados: [Gasto] = []
    for gasto in gastos {
        let valor = gasto.valor
        if (valor <= max) {
            gastosFiltrados.append(gasto)
        }
    }
    return gastosFiltrados
}

// filtra o vetor de gastos pela categoria
public func filtraCategoria(categoriaFiltro: String, gastos: [Gasto]) -> [Gasto] {
    // gera o novo vetor
    var gastosFiltrados: [Gasto] = []
    for gasto in gastos {
        let categ = gasto.categoria
        if (categ == categoriaFiltro) {
            gastosFiltrados.append(gasto)
        }
    }
    return gastosFiltrados
}

/*
// passando zero retorna os gastos de hoje
func filtraUltimosDias(dias: Int) {
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
    self.gastos = gastosUltimosDias
}
*/

