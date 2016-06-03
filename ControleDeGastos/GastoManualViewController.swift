//
//  GastoManualViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit


class GastoManualViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UINavigationBarDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var nomeGasto: UITextField!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    @IBOutlet weak var botaoQRCode: UIButton!
    
    // variaveis do QRCode
    var valortotal:Double!
    var dataQR: String!
    
    // variaveis internas para controle de tempo
    var dataNs = NSDate()
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    
    // variaveis internas para controle de dados
    var dataStr = String()
    var categoria = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoria = "Outros"
        view.backgroundColor = corAzul
        if (eamarela)
        {
            view.backgroundColor = corAmarela
        }
        if (evermelha)
        {
            view.backgroundColor = corVermelha
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GastoManualViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account

        navigationBar.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Gasto Manual"

        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action:(#selector(GastoManualViewController.btn_clicked(_:))))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        calendar.components([.Day , .Month , .Year], fromDate: dataNs)
        
        
        categoriaPickerView.delegate = self
        categoriaPickerView.dataSource = self
        
        valor.delegate = self
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if valortotal != nil
        {
            valor.text=String(valortotal)
        }
        print(valor.text!)
        valor.keyboardType = .NumberPad
        if dataQR != nil
        {
            dataStr = dataQR
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datefromstring = dateFormatter.dateFromString(dataQR)
            datePicker.date = datefromstring!
            
        }
        else
        {
            let components = self.calendar.components([.Day , .Month , .Year], fromDate: self.dataNs)
            self.dataStr = "\(components.year)-\(components.month)-\(components.day)"
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func btn_clicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("GastoToMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "GastoToMain" {
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
        } else if segue.identifier == "GastoManualToQRCode" {
            let vc = segue.destinationViewController as! QRCodeViewController
            vc.delegate = self
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoria = userLogged.categories[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return (userLogged.categories.count)

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (userLogged.categories[row])

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return !(textField.placeholder == "Categoria")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        dataNs = datePicker.date
        dataQR = dateFormatter.stringFromDate(dataNs)
        let dataaux = dataQR.stringByReplacingOccurrencesOfString("/", withString: "-")
        let fullNameArr = dataaux.componentsSeparatedByString("-")
        let stringfinal = "20" + fullNameArr[2] + "-" + fullNameArr [0] + "-" + fullNameArr[1]
        dataStr = stringfinal
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
            for categ in userLogged.categories             {
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
                userLogged.addCategoriaGasto(textField.text!)
                
                // adiciona no cloud
                dispatch_async(dispatch_get_main_queue(),{
                    
                    DAOCloudKit().addCategory(userLogged)
                })
                
                // atualiza label de categoria
                self.categoria = textField.text!
                // atualiza pickerView
                self.categoriaPickerView.reloadAllComponents()
                self.categoriaPickerView.selectRow((userLogged.categories.count)-1, inComponent: 0, animated: true)
                print("passou")
            }
        }))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    @IBAction func apertouBotaoQRCode(sender: AnyObject) {
        performSegueWithIdentifier("GastoManualToQRCode", sender: self)
    }
    
    
    @IBAction func gasteiAction(sender: AnyObject) {
        let nome = nomeGasto.text
        let valorgasto = Double(valor.text!)?.roundToPlaces(2)
        
        // nao pode usar variavel sem verificar se eh nil antes
        if(valorgasto == nil) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu o valor do gasto", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(self.dataStr == "" || self.dataStr.isEmpty) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu a data", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(nome == nil || nome!.isEmpty) {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu o nome", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if(categoria == "") {
            let alert = UIAlertController(title: "Warning", message: "Você não preencheu a categoria", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            

            let gasto = Gasto(nome: nome!, categoria: self.categoria, valor: valorgasto!, data: self.dataStr)
            // adiciona na RAM
            userLogged.addGasto(gasto)
            // adiciona no disco
            DAOCloudKit().addGasto(gasto)
            //base.adicionarGasto(gasto, usuario: base.usuarioLogado!)
            // faz o segue
            performSegueWithIdentifier("GastoToMain", sender: self)
        }
    }
}
