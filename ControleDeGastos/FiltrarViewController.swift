//
//  FiltrarViewController.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 03/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class FiltrarViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var textValorMin: UITextField!
    @IBOutlet weak var textValorMax: UITextField!
    
    @IBOutlet weak var pickerDataMin: UIDatePicker!
    @IBOutlet weak var pickerDataMax: UIDatePicker!
    
    @IBOutlet weak var pickerCategorias: UIPickerView!
    
    @IBOutlet weak var botaoCancelar: UIButton!
    @IBOutlet weak var botaoSalvar: UIButton!
    
    var gastos = [Gasto]()
    var categoria : String!
    var delegate = HistoricoTabelaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.50, green:0.71, blue:0.52, alpha:1.0)
        
        // inicialmente carrega todos os gastos
        self.gastos = base.usuarioLogado!.getGastos()
        pickerCategorias.delegate = self
        pickerCategorias.dataSource = self
        botaoCancelar.titleLabel!.textColor = UIColor.whiteColor()
        botaoSalvar.titleLabel!.textColor = UIColor.whiteColor()
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
        let min = (textValorMin.text!).toDouble()!
        let max = (textValorMax.text!).toDouble()!
        // filtros de valor minimo e maximo
        if (!min.isZero && !max.isZero) {
            self.gastos = filtraValor( min, max: max, gastos: self.gastos )
        } else if (!min.isZero) {
            self.gastos = filtraValorMin( min, gastos: self.gastos )
        } else if (!max.isZero) {
            self.gastos = filtraValorMax( max, gastos: self.gastos )
        }
        
        // altera os dados da historicoTabela
        self.delegate.gastos = self.gastos
        // desfaz o segue
        dismissViewControllerAnimated(true, completion: nil)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (base.usuarioLogado!.categoriasGastos.count)
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (base.usuarioLogado!.categoriasGastos[row])
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria = base.usuarioLogado!.categoriasGastos[row]
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

}
