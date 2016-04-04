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
