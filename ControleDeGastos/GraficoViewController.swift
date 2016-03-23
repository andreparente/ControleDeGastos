//
//  GraficoViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
import UIKit
import Charts

class ViewController: UIViewController,ChartViewDelegate {
    
    
    // AQUI ELE CRIA A VIEW PRO GRAFICO
    let chartView = PieChartView(frame: CGRectMake(0, 22, 400, 400))
    var categorias: [String]!
    var gastos: [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chartView.center = view.center
        //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
        chartView.noDataText = "You need to enter some data"
        chartView.delegate = self
        chartView.animate(xAxisDuration: 1)
        view.addSubview(chartView)
        setChart(categorias, values: gastos)
    }
    
    //FUNCAO QUE SETTA TODO O GRAFICO
    func setChart(dataPoints: [String], values: [Double]) {
        
        chartView.noDataText = "You need to provide data for the chart."
        chartView.descriptionText = "Tamo quase lá!"
        
        var dataEntries: [ChartDataEntry] = []
        //ESSE FOR PREENCHE O VETOR DE ENTRADA DE DADOS, PRA CADA INDEX,
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
        }
        
        //ISSO EU NAO ENTENDI MUITO BEM MAS FUNCIONA
        let chartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        
        chartDataSet.colors = ChartColorTemplates.liberty()
        
        
        let chartData = PieChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        
        
    }
    
    // FUNCAO CHAMADA QUANDO CLICAMOS EM CIMA DE UM PEDACO DA PIZZA
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(categorias[entry.xIndex])")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

