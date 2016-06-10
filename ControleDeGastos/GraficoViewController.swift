
//
//  GraficoViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
import UIKit
import Charts

class GraficoViewController: UIViewController,ChartViewDelegate,UITextFieldDelegate {
    
    // AQUI ELE CRIA A VIEW PRO GRAFICO
    @IBOutlet weak var chartView: PieChartView!
    
    @IBOutlet weak var dataMesTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var limiteLabel: UILabel!
    @IBOutlet weak var pickermesano: MonthYearPickerView!
    var gastos: [Gasto]!
    var total = 0.0
    var dataNs = NSDate()
    var dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    var dataString: String!
    var vetorFinal: [Double] = []
    var vetorFinalCat: [String] = []
    var vetorGastosMes: [Gasto] = []
    var vetorFinalCatMes: [String] = []
    var vetorFinalGastosMes: [Double] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickermesano.grafico = self
        view.backgroundColor = corAzul
        if (eamarela)
        {
            view.backgroundColor = corAmarela
        }
        if (evermelha)
        {
            view.backgroundColor = corVermelha
        }

        dataMesTextField.delegate = self
        pickermesano.hidden = true
        dataMesTextField.inputView = pickermesano
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle

        
        calendar.components([.Year , .Month], fromDate: dataNs)
        chartView.delegate = self
        chartView.backgroundColor = corVerde

    }
    
    //Funcao para organizar o grafico
   func organizaVetores(usuario: User) -> ([Double],[String]) {
        
        var vetValAux = [Double?](count: userLogged.categories.count,repeatedValue: nil)
        var vetValAux2: [Double] = []
        var vetCatAux: [String] = []
        for i in 0..<userLogged.categories.count  {
            vetValAux[i] = 0
        }
    
    print( " VETOR QUANTIDADE DE CATEGORIAS E VALORES ZERADOS: ", vetValAux)
    
        for i in 0..<userLogged.categories.count {
            
            for gasto in usuario.gastos {
                print(gasto.category)
                print(usuario.categories[i])
                if(gasto.category == usuario.categories[i]) {
                    if(existeCategoria(vetCatAux, categoria: gasto.category) == false) {
                        vetCatAux.append(gasto.category)
                    }
                    print(vetValAux)
                    print(gasto.value)
                    vetValAux[i] = vetValAux[i]! + gasto.value
                    
                }
            }
        }
        
        for i in 0..<vetValAux.count {
            
            if(vetValAux[i] > 0) {
                print(vetValAux2)
                vetValAux2.append(vetValAux[i]!)
            }
        }
    
    print(vetValAux2)
    print(vetCatAux)
        return (vetValAux2,vetCatAux)
    }

    func existeCategoria(vetor: [String],categoria: String) -> Bool {
        
        for auxVet in vetor {
            if(auxVet == categoria) {
                return true
            }
        }
        return false
    }
    
    func organizaVetoresMes(usuario: User, gastosMes: [Gasto]) -> ([Double],[String]) {



        var vetCatAux: [String] = []
        var vetValAux: [Double] = []
        for i in 0..<gastosMes.count {

            for categorias in userLogged.getCategorias()  {
                if(gastosMes[i].category == categorias) {
                    if(!existeCategoria(vetCatAux, categoria: categorias)) {
                    vetCatAux.append(categorias)
                    vetValAux.append(0)
                    }
                }
            }
        }

        for i in 0..<vetCatAux.count {
            for valGasto in gastosMes {
                if(valGasto.category == vetCatAux[i]) {
                    vetValAux[i] = vetValAux[i] + valGasto.value
                }
            }
        }
        
        return (vetValAux,vetCatAux)


    }

    //FUNCAO QUE PRINTA LIMITE
    func printaLimite(usuario: User) {
        if(usuario.limiteMes == 0) {
            limiteLabel.text = "Você não disponibilizou o limite por mês"
        }
        else {
            //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
            chartView.noDataText = "You need to enter some data"
            chartView.delegate = self
            chartView.animate(xAxisDuration: 1)
            limiteLabel.text = "Seu limite é \(usuario.limiteMes)"
        }
    }
    
    
    //FUNCAO QUE SETTA TODO O GRAFICO
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        var dataEntries: [ChartDataEntry] = []
        chartView.descriptionText = "Gastos"
        //ESSE FOR PREENCHE O VETOR DE ENTRADA DE DADOS, PRA CADA INDEX,
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        //ISSO EU NAO ENTENDI MUITO BEM MAS FUNCIONA
        let chartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        let chartData = PieChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
    }
   
    // FUNCAO CHAMADA QUANDO CLICAMOS EM CIMA DE UM PEDACO DA PIZZA
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(userLogged.categories[entry.xIndex])")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField.placeholder == "Escolha o mês e ano") {
            //dataMesDatePicker.hidden = false
            pickermesano.hidden = false
            return false
        }
        else {
            pickermesano.hidden = true
        }
        return true
    }
    override func viewWillAppear(animated: Bool) {
        executar = false
        total = 0.0
        printaLimite(userLogged)
        if(userLogged.gastos.count == 0) {
            
            //NO DATA TEXT OCORRE QUANDO NAO TEM DADOS NO GRAFICO
            chartView.noDataText = "Você não possui nenhum gasto!"
            chartView.delegate = self
            chartView.animate(xAxisDuration: 1)
            
        }
        else {
            
            for gasto in userLogged.getGastosUltimoMês(){
                total = total + gasto.value
            }
            print("--------- TOTAL DE TODOS OS GASTOS DO USUARIO DA VIDA:  ", total)
            (vetorFinal,vetorFinalCat) = organizaVetores(userLogged)
            print("vetor de valores", vetorFinal)
            print("vetor de categorias", vetorFinalCat)
            setChart(vetorFinalCat, values: vetorFinal)
            totalLabel.text = "Total: R$"+String(total)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        pickermesano.hidden = true
        dataMesTextField.text = ""
    }
    /*
   @IBAction func DatePickerChanged(sender: AnyObject) {
        dataNs = dataMesDatePicker.date
        dataString = dateFormatter.stringFromDate(dataMesDatePicker.date)
        let dataaux = dataString.stringByReplacingOccurrencesOfString("/", withString: "-")
        let fullNameArr = dataaux.componentsSeparatedByString("-")
        let stringfinal = "20" + fullNameArr[2] + "-" + fullNameArr [0] + "-" + fullNameArr[1]
        print("dataString: ", stringfinal)
        dataMesTextField.text = dataString
        let data = stringfinal.componentsSeparatedByString("-")
        // data == [mes, dia, ano]
        print(data)
        let mesGasto = Int(data[1])!
        let anoGasto = Int(data[0])!
    print(mesGasto);print(anoGasto)
        vetorGastosMes = userLogged.getGastosUltimoMês()
        (vetorFinalGastosMes,vetorFinalCatMes) = organizaVetoresMes(userLogged, gastosMes: vetorGastosMes)
        
        print("vetor final depois do organizaVetores: ",vetorFinalGastosMes)
        print("vetor final depois do organizaVetores: ",vetorFinalCatMes)
        setChart(vetorFinalCatMes, values: vetorFinalGastosMes)
 
    }
 */
}

