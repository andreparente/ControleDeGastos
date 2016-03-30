//
//  GraficoViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
import UIKit
import Charts

class GraficoViewController: UIViewController,ChartViewDelegate {
    
    
    // AQUI ELE CRIA A VIEW PRO GRAFICO
    let chartView = PieChartView(frame: CGRectMake(0, screenSize.height/6, screenSize.width, screenSize.height/2))
    let totalLabel = UILabel(frame: CGRectMake(0, screenSize.height-(screenSize.height/3), screenSize.width,40))
    var valoresGastos: [Double] = []
    var gastos: [Gasto]!
    var total = 0.0
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        chartView.delegate = self
        view.addSubview(chartView)
        view.addSubview(totalLabel)
        chartView.animate(xAxisDuration: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }
    
    //FUNCAO QUE SETTA TODO O GRAFICO
    func setChart(dataPoints: [String], values: [Double]) {
        print("Funcao executando")
        chartView.descriptionText = "Resumo"
        print(values.count)
        var dataEntries: [ChartDataEntry] = []
        
        //ESSE FOR PREENCHE O VETOR DE ENTRADA DE DADOS, PRA CADA INDEX,
        for i in 0..<values.count {
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            
            dataEntries.append(dataEntry)
        }
        print(dataEntries)
        //ISSO EU NAO ENTENDI MUITO BEM MAS FUNCIONA
        let chartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        
        chartDataSet.colors = ChartColorTemplates.liberty()
        
        
        let chartData = PieChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        
        
    }
    
    // FUNCAO CHAMADA QUANDO CLICAMOS EM CIMA DE UM PEDACO DA PIZZA
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(base.usuarioLogado?.categoriasGastos[entry.xIndex])")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        for gasto in base.usuarioLogado!.gastos {
            print("gasto ", gasto.nome)
        }
        total = 0.0
        if(base.usuarioLogado?.gastos.count == 0) {
            
            //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
            chartView.noDataText = "You need to enter some data"
            chartView.delegate = self
            chartView.animate(xAxisDuration: 1)
            //setChart((base.usuarioLogado?.categoriasGastos)!, values: valoresGastos)
            
            
        }
        else {
            
            var i: Int = 0
            for gasto in base.usuarioLogado!.gastos {
                
                valoresGastos.append(Double(gasto.valor))
                print("Valores gastos: ", valoresGastos[i])
                total = total+Double(gasto.valor)
                print("total: ", total)
                i++
            }
            setChart((base.usuarioLogado?.categoriasGastos)!, values: valoresGastos)
            totalLabel.text = "Total: R$"+String(total)
        }

    }
    
    
}

