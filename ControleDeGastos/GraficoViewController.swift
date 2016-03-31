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
    let limiteLabel = UILabel(frame: CGRectMake(0, screenSize.height-(screenSize.height/3)+50, screenSize.width,40))
    var gastos: [Gasto]!
    var total = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        chartView.delegate = self
        view.addSubview(chartView)
        view.addSubview(totalLabel)
        view.addSubview(limiteLabel)
        printaLimite(base.usuarioLogado!)
        chartView.animate(xAxisDuration: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //Funcao para organizar o grafico
    func organizaVetores(usuario: Usuario) -> ([Double?]) {
        
        var vetValAux = [Double?](count: usuario.categoriasGastos.count,repeatedValue: nil)
        for i in 0..<usuario.categoriasGastos.count {
            vetValAux[i] = 0
        }
        for i in 0..<usuario.categoriasGastos.count {
            for valGasto in usuario.gastos {
                if(valGasto.categoria == usuario.categoriasGastos[i]) {
                    vetValAux[i] = vetValAux[i]! + Double(valGasto.valor)
                }
            }
        }
        return vetValAux
    }
    
    //FUNCAO QUE PRINTA LIMITE
    func printaLimite(usuario: Usuario) {
        if(usuario.limiteMes == 0) {
            limiteLabel.text = "Você não disponibilizou o limite por mês"
        }
        else {
            
            //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
            chartView.noDataText = "You need to enter some data"
            chartView.delegate = self
            chartView.animate(xAxisDuration: 1)
            view.addSubview(chartView)
            limiteLabel.text = "Seu limite é \(usuario.limiteMes)"
        }
    }
    
    
    //FUNCAO QUE SETTA TODO O GRAFICO
    func setChart(dataPoints: [String], values: [Double?]) {
        chartView.descriptionText = "Resumo"
        
        var dataEntries: [ChartDataEntry] = []
        
        //ESSE FOR PREENCHE O VETOR DE ENTRADA DE DADOS, PRA CADA INDEX,
        for i in 0..<values.count {
            
            let dataEntry = ChartDataEntry(value: values[i]!, xIndex: i)
            
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
    
    override func viewWillAppear(animated: Bool) {
        for gasto in base.usuarioLogado!.gastos {
            print("gasto ", gasto.nome)
        }
        total = 0.0
        if(base.usuarioLogado?.gastos.count == 0) {
            
            //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
            chartView.noDataText = "Você não possui nenhum gasto!"
            chartView.delegate = self
            chartView.animate(xAxisDuration: 1)
            
        }
        else {
            
            for gasto in base.usuarioLogado!.gastos {
                
                total = total+Double(gasto.valor)
            }
            var vetor: [Double?]
            vetor = organizaVetores(base.usuarioLogado!)
            setChart((base.usuarioLogado?.categoriasGastos)!, values: vetor)
            totalLabel.text = "Total: R$"+String(total)
        }
        
    }
    
    
}

