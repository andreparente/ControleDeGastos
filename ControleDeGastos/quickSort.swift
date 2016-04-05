//
//  quickSort.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 04/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation

/*
class QuickSortClass {
    var v = [Int]()
    
    internal func partition(left: Int, right: Int) -> Int {
        var i = left
        for j in (left + 1)..<(right + 1) {
            if v[j] < v[left] {
                i += 1
                (v[i], v[j]) = (v[j], v[i])
            }
        }
        (v[i], v[left]) = (v[left], v[i])
        return i
    }
    
    internal func quicksort(left: Int, right: Int) {
        if right > left {
            let pivotIndex = partition(left, right: right)
            quicksort(left, right: pivotIndex - 1)
            quicksort(pivotIndex + 1, right: right)
        }
    }
    
    func callQuickSort () {
        quicksort(0, right: v.count-1)
    }
}

// exemplo de uso:

var randomNumbers = [42, 12, 88, 62, 63, 56, 1, 77, 88, 97, 97, 20, 45, 91, 62, 2, 15, 31, 59, 5]
print (randomNumbers)
let QS = QuickSortClass()
QS.v = randomNumbers
QS.callQuickSort()
randomNumbers = QS.v
print (randomNumbers)


*/

class QuickSorterGasto {
    var v = [Gasto]()
    var decrescente = false
    
    func callQuickSort (ordenacao: String, decrescente: Bool) {
        self.decrescente = decrescente
        if (ordenacao == "Data") {
            quicksortData(0, right: v.count-1)
        } else if (ordenacao == "Nome") {
            quicksortNome(0, right: v.count-1)
        } else if (ordenacao == "Valor") {
            quicksortValor(0, right: v.count-1)
        }
    }
    
    internal func partitionData(left: Int, right: Int) -> Int {
        var i = left
        for j in (left + 1)..<(right + 1) {
            var precisaTrocar = v[j].data < v[left].data
            
            // inverte a verificacao para ordenar ao contrario
            if (self.decrescente) {
                precisaTrocar = !precisaTrocar
            }
            
            if precisaTrocar {
                i += 1
                (v[i], v[j]) = (v[j], v[i])
            }
        }
        (v[i], v[left]) = (v[left], v[i])
        return i
    }
    
    internal func quicksortData(left: Int, right: Int) {
        if right > left {
            let pivotIndex = partitionData(left, right: right)
            quicksortData(left, right: pivotIndex - 1)
            quicksortData(pivotIndex + 1, right: right)
        }
    }
    
    internal func partitionNome(left: Int, right: Int) -> Int {
        var i = left
        for j in (left + 1)..<(right + 1) {
            var precisaTrocar = v[j].nome < v[left].nome
            
            // inverte a verificacao para ordenar ao contrario
            if (self.decrescente) {
                precisaTrocar = !precisaTrocar
            }
            
            if precisaTrocar {
                i += 1
                (v[i], v[j]) = (v[j], v[i])
            }
        }
        (v[i], v[left]) = (v[left], v[i])
        return i
    }
    
    internal func quicksortNome(left: Int, right: Int) {
        if right > left {
            let pivotIndex = partitionNome(left, right: right)
            quicksortNome(left, right: pivotIndex - 1)
            quicksortNome(pivotIndex + 1, right: right)
        }
    }
    
    internal func partitionValor(left: Int, right: Int) -> Int {
        var i = left
        for j in (left + 1)..<(right + 1) {
            var precisaTrocar = v[j].valor < v[left].valor
            
            // inverte a verificacao para ordenar ao contrario
            if (self.decrescente) {
                precisaTrocar = !precisaTrocar
            }
            
            if precisaTrocar {
                i += 1
                (v[i], v[j]) = (v[j], v[i])
            }
        }
        (v[i], v[left]) = (v[left], v[i])
        return i
    }
    
    internal func quicksortValor(left: Int, right: Int) {
        if right > left {
            let pivotIndex = partitionValor(left, right: right)
            quicksortValor(left, right: pivotIndex - 1)
            quicksortValor(pivotIndex + 1, right: right)
        }
    }
}