//
//  PickerView.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 5/31/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years: [Int]!
    var vetorFinalCatMes: [String] = []
    var vetorFinalGastosMes: [Double] = []
    var vetorGastosMes: [Gasto] = []
    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year: Int = 0 {
        didSet {
            selectRow(years.indexOf(year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((month: Int, year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Year, fromDate: NSDate())
            for _ in 1...5 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        self.delegate = self
        self.dataSource = self
        
        let month = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.component(.Month, fromDate: NSDate())
        self.selectRow(month-1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRowInComponent(0)+1
        let year = years[self.selectedRowInComponent(1)]
        if let block = onDateSelected {
            block(month: month, year: year)
        }
        self.month = month
        self.year = year
        let mes :Int =  month
        let ano :Int = year
        print(month);print(year)
        vetorGastosMes = base.usuarioLogado!.getGastosMes(mes,ano: ano)
        (vetorFinalGastosMes,vetorFinalCatMes) = GraficoViewController().organizaVetoresMes(base.usuarioLogado!, gastosMes: vetorGastosMes)
        print("vetor final depois do organizaVetores: ",vetorFinalGastosMes)
        print("vetor final depois do organizaVetores: ",vetorFinalCatMes)
        GraficoViewController().setChart(vetorFinalCatMes, values: vetorFinalGastosMes)
    }
    
}