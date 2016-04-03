//
//  GastoManualViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit


class GastoManualViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UINavigationBarDelegate {
    
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
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        /*
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GastoManualViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        */
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Gasto"
/*
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action:(#selector(GastoManualViewController.btn_clicked(_:))))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
  */  
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        calendar.components([.Day , .Month , .Year], fromDate: dataNs)
        
        categoriaPickerView.delegate = self
        categoriaPickerView.dataSource = self
        categoriaPickerView.hidden = true
        categoria.delegate = self
        nomeGasto.delegate = self
        valor.delegate = self
        categoria.inputView = categoriaPickerView
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if valortotal != nil
        {
            valor.text=String(valortotal)
        }
        print(valor.text!)
        valor.keyboardType = .NumberPad
        if data != nil
        {
            dateLabel.text = data
        }
        else
        {
            let datacrazy = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: datacrazy)
            dateLabel.text = "\(components.year)-\(components.month)-\(components.day)"
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func btn_clicked(sender: UIBarButtonItem) {
        // Do something
        performSegueWithIdentifier("GastoToMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "GastoToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria.text = base.usuarioLogado!.categoriasGastos[row]
        categoriaPickerView.hidden = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print(base.usuarioLogado?.categoriasGastos.count)
        return (base.usuarioLogado?.categoriasGastos.count)!
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (base.usuarioLogado!.categoriasGastos[row])!
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField.placeholder == "Categoria") {
            categoriaPickerView.hidden = false
            return false
        }
        else {
            categoriaPickerView.hidden = true
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        dataNs = date.date
        data = dateFormatter.stringFromDate(dataNs)
        dateLabel.text = data
    }
    @IBAction func novacategoria(sender: UIButton) {
        let alert=UIAlertController(title:"Categoria", message: "Insira uma nova categoria abaixo", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (field) -> Void in
            field.placeholder = "Insira nova categoria"})
        alert.addAction(UIAlertAction(title:"Cancelar",style: UIAlertActionStyle.Cancel,handler: nil))
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{ (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            //print("Text field: \(textField.text!)")
            var naoExiste = true
            for categ in (base.usuarioLogado?.categoriasGastos)!
            {
                if textField.text == categ {
                    let alert2=UIAlertController(title:"Erro", message: "Categoria já existe", preferredStyle: UIAlertControllerStyle.Alert)
                    alert2.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Cancel,handler: nil))
                    self.presentViewController(alert2,animated: true, completion: nil)
                    naoExiste = false
                }
            }
            if (naoExiste)
            {
                // adiciona na RAM
                base.usuarioLogado!.addCategoriaGasto(textField.text!)
                // adiciona no disco
                base.editarUsuario(base.usuarioLogado!)
                self.categoria.text = textField.text
                // atualiza pickerView
                self.categoriaPickerView.reloadAllComponents()
            }
        }))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    @IBAction func gasteiAction(sender: AnyObject) {
        let nome = nomeGasto.text
        let categoria = self.categoria.text
        let valorgasto = Double(valor.text!)?.roundToPlaces(2)
        let data = dateLabel.text
        // nao pode usar variavel sem verificar se eh nil antes
        if(valorgasto == nil) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu o valor do gasto", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(data == nil || data!.isEmpty) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu a data", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(nome == nil || nome!.isEmpty) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu o nome", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(categoria == nil || categoria!.isEmpty) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu a categoria", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let gasto = Gasto(nome: nome!, categoria: categoria!, valor: Int(valorgasto!), data: data!)
            // adiciona na RAM
            base.usuarioLogado?.addGasto(gasto)
            // adiciona no disco
            base.adicionarGasto(gasto, usuario: base.usuarioLogado!)
            // faz o segue
            performSegueWithIdentifier("GastoToMain", sender: self)
        }
    }
}
