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
    var categoriaSelecionada : String! // armazena o valor do pickerView categorias
    var categorias = [String]()
    var delegate = HistoricoTabelaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.50, green:0.71, blue:0.52, alpha:1.0)
        
        // inicialmente carrega todos os gastos
        self.gastos = base.usuarioLogado!.getGastos()
        
        // preenche vetor de categorias e adiciona "Todas"
        self.categorias.append("Todas")
        self.categorias.appendContentsOf(base.usuarioLogado!.getCategoriasGastos())
        
        // inicialmente, o valor da categoria selecionada eh Todas
        self.categoriaSelecionada = "Todas"
        
        pickerCategorias.delegate = self
        pickerCategorias.dataSource = self
        
        botaoCancelar.titleLabel!.textColor = UIColor.whiteColor()
        botaoSalvar.titleLabel!.textColor = UIColor.whiteColor()
    }
    
    @IBAction func apertouBotaoCancelar(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func apertouBotaoSalvar(sender: AnyObject) {
        // filtros de valor minimo e maximo
        let min = (textValorMin.text!).toDouble()!
        let max = (textValorMax.text!).toDouble()!
        if (!min.isZero && !max.isZero) {
            self.gastos = filtraValor( min, max: max, gastos: self.gastos )
        } else if (!min.isZero) {
            self.gastos = filtraValorMin( min, gastos: self.gastos )
        } else if (!max.isZero) {
            self.gastos = filtraValorMax( max, gastos: self.gastos )
        }
        
        // filtro de categorias
        if (categoriaSelecionada != "Todas") {
            self.gastos = filtraCategoria(self.categoriaSelecionada, gastos: self.gastos)
        }
        
        // filtro de data
        self.gastos =  filtroData(pickerDataMin.date, data2: pickerDataMax.date, gastos: self.gastos)
        
        // altera os dados da historicoTabela
        self.delegate.gastos = self.gastos
        // desfaz o segue
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categorias.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categorias[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoriaSelecionada = self.categorias[row]
    }

    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destino = segue.destinationViewController as! HistoricoTabelaViewController
    }
    */
    }
