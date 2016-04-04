//
//  FiltrarViewController.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 03/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class FiltrarViewController: UIViewController {

    @IBOutlet weak var textValorMin: UITextField!
    @IBOutlet weak var textValorMax: UITextField!
    
    @IBOutlet weak var pickerDataMin: UIDatePicker!
    @IBOutlet weak var pickerDataMax: UIDatePicker!
    
    @IBOutlet weak var pickerCategorias: UIPickerView!
    
    @IBOutlet weak var botaoCancelar: UIButton!
    @IBOutlet weak var botaoSalvar: UIButton!
    
    var gastos = [Gasto]()
    
    var delegate = HistoricoTabelaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.50, green:0.71, blue:0.52, alpha:1.0)
        
        // inicialmente carrega todos os gastos
        self.gastos = base.usuarioLogado!.getGastos()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apertouBotaoCancelar(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func apertouBotaoSalvar(sender: AnyObject) {
        // filtros de valor minimo e maximo
        if (textValorMax.text != "" && textValorMin.text != "") {
            filtraValor(Int(textValorMin.text!)!, max: Int(textValorMax.text!)!)
        } else if (textValorMin.text != "") {
            filtraValorMin(Int(textValorMin.text!)!)
        } else if (textValorMax.text != "") {
            filtraValorMax(Int(textValorMax.text!)!)
        }

        // altera os dados da historicoTabela
        self.delegate.gastos = self.gastos
        // desfaz o segue
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destino = segue.destinationViewController as! HistoricoTabelaViewController
    }
    */
    
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
    // filtra o vetor de gastos pelo intervalo de valores
    func filtraValor(min: Int, max: Int) {
        // gera o novo vetor
        var gastosFiltrado: [Gasto] = []
        for gasto in self.gastos {
            let valor = gasto.valor
            if (valor >= min && valor <= max) {
                gastosFiltrado.append(gasto)
            }
        }
        self.gastos = gastosFiltrado
    }
    
    // filtra o vetor de gastos pelo valor minimo
    func filtraValorMin(min: Int) {
        // gera o novo vetor
        var gastosFiltrado: [Gasto] = []
        for gasto in self.gastos {
            let valor = gasto.valor
            if (valor >= min) {
                gastosFiltrado.append(gasto)
            }
        }
        self.gastos = gastosFiltrado
    }
    
    // filtra o vetor de gastos pelo valor maximo
    func filtraValorMax(max: Int) {
        // gera o novo vetor
        var gastosFiltrado: [Gasto] = []
        for gasto in self.gastos {
            let valor = gasto.valor
            if (valor <= max) {
                gastosFiltrado.append(gasto)
            }
        }
        self.gastos = gastosFiltrado
    }
    

}
