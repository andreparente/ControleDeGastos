//
//  FiltrarViewController.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 03/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class FiltrarViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var textValorMin: UITextField!
    @IBOutlet weak var textValorMax: UITextField!
    
    @IBOutlet weak var pickerDataMin: UIDatePicker!
    @IBOutlet weak var pickerDataMax: UIDatePicker!
    
    @IBOutlet weak var pickerCategorias: UIPickerView!
    
    @IBOutlet weak var botaoCancelar: UIButton!
    @IBOutlet weak var botaoSalvar: UIButton!
    
    @IBOutlet weak var background_image: UIImageView!
    
    var categoriaSelecionada : String! // armazena o valor do pickerView categorias
    var categorias = [String]()
    var delegate = HistoricoTabelaViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FiltrarViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        /* if (eamarela)
         {
         view.backgroundColor = corAmarela
         }
         */
        if (evermelha)
        {
            //self.background_image.image = UIImage(named: "background_red.png")
            view.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
        }
        
        // inicialmente, o vetor eh o do usuario
        gastosGlobal = userLogged.getGastos()
        
        // preenche vetor de categorias e adiciona "Todas"
        self.categorias.append("Todas")
        self.categorias.appendContentsOf(userLogged.getCategorias())
        
        // inicialmente, o valor da categoria selecionada eh Todas
        self.categoriaSelecionada = "Todas"
        
        pickerCategorias.delegate = self
        pickerCategorias.dataSource = self
        
        // configurando os valores iniciais dos pickerView de data
        // pega a data de hoje e seus components
        let dataHoje = NSDate()
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: dataHoje)
        // altera o dia pra 1
        components.day = 1
        // pega a data gerada com dia 1
        let primeiroDiaMes = NSDate().createFromDate(components.day, mes: components.month, ano: components.year)
        // altera o pickerDate minimo
        self.pickerDataMin.setDate(primeiroDiaMes, animated: false)
        
        botaoCancelar.titleLabel!.textColor = UIColor.whiteColor()
        botaoSalvar.titleLabel!.textColor = UIColor.whiteColor()
        textValorMax.delegate = self
        textValorMin.delegate = self
        textValorMin.keyboardType = .DecimalPad
        textValorMax.keyboardType = .DecimalPad
    }
    
    @IBAction func apertouBotaoCancelar(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func apertouBotaoSalvar(sender: AnyObject) {
        
        // filtros de valor minimo e maximo
        var minVal = (textValorMin.text!).toDouble()!
        var maxVal = (textValorMax.text!).toDouble()!
        
        if (minVal.isZero) {
            minVal = 0
        }
        if (maxVal.isZero) {
            maxVal = 100000000000
        }
        

        

        
        //filtro geral foda-se
        print(pickerDataMin.date)
        print(pickerDataMax.date)
        gastosGlobal = DAOLocal().filtrarPorDataCategoriaPreço(pickerDataMin.date, toDate: pickerDataMax.date, fromPrice: minVal, toPrice: maxVal, category: categoriaSelecionada)
        
        // altera os dados da historicoTabela
        delegate.filtrou = true
        // desfaz o segue
        print(gastosGlobal)
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
    
    //karina - funcao para deixar a fonte do picker branca
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = categorias[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Tsukushi A Round Gothic", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
