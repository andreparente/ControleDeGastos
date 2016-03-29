//
//  GastoManualViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

/*func formatADate() {
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let d = NSDate()
    let s = dateFormatter.stringFromDate(d)
    print(s)
}*/
class GastoManualViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var categoria: UITextField!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var nomeGasto: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    
    var valortotal:Double!
    var data:String!
    var dataNs = NSDate()
    var dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        

        calendar.components([.Day , .Month , .Year], fromDate: dataNs)
        
        super.viewDidLoad()
        categoriaPickerView.delegate = self
        categoriaPickerView.dataSource = self
        categoriaPickerView.hidden = true
        categoria.delegate = self
        categoria.inputView = categoriaPickerView


        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        valor.text=String(valortotal)
        dateLabel.text = data
        // Do any additional setup after loading the view.
        

        //TESTE
        usuarioLogado = Usuario(nome: "A", email: "aa@a.c", senha: "1")
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria.text = usuarioLogado?.categoriasGastos[row]
        categoriaPickerView.hidden = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (usuarioLogado?.categoriasGastos.count)!
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usuarioLogado?.categoriasGastos[row]
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        categoriaPickerView.hidden = false
        return false
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        
        dataNs = date.date
        data = dateFormatter.stringFromDate(dataNs)
        dateLabel.text = data
        
    }
    

    @IBAction func gasteiAction(sender: AnyObject) {
        if(valor.text! == "nil" || valor.text!.isEmpty) {
            
        let alert = UIAlertController(title: "Warning", message: "Você não preencheu o valor do gasto", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier("GastoToMain", sender: self)
        
        
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "GastoToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
            
        }
        
    }
 
    @IBAction func Add(sender: UIButton) {
        
    }
    


}
