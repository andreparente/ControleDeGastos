//
//  SettingsViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
var alteroulim = false
class SettingsViewController: UIViewController, UINavigationBarDelegate{
    
    var field:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = corAzul
        if (eamarela)
        {
            view.backgroundColor = corAmarela
        }
        if (evermelha)
        {
            view.backgroundColor = corVermelha
        }

        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        navigationBar.delegate = self;

        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Settings"

    // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsViewController.btn_clicked(_:)))
        
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton

        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func limite(sender: UIButton) {
        
        let alert=UIAlertController(title:" Seu limite e:\(userLogged.getLimiteMes())", message: "Mude seu limite abaixo:", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (field) -> Void in
            field.placeholder = "Insira seu limite"})
        alert.addAction(UIAlertAction(title:"Cancelar",style: UIAlertActionStyle.Cancel,handler: nil))
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{ (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            
            userLogged.setLimiteMes(Double(textField.text!)!)
            print("LIMITE DO USUARIO USERLOGGED LOCAL::::", userLogged.limiteMes)
            DAOCloudKit().changeLimit(userLogged)
            alteroulim = true
        }))
        
        
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    func btn_clicked(sender: UIBarButtonItem) {
        if alteroulim == true
        {
            executar = true
        }
        else
        {
            executar = false
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func categoria(sender: UIButton) {
        let alert=UIAlertController(title:"Categoria", message: "Insira uma nova categoria abaixo", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (field) -> Void in
            field.placeholder = "Insira nova categoria"})
        alert.addAction(UIAlertAction(title:"Cancelar",style: UIAlertActionStyle.Cancel,handler: nil))
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{ (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            var naoExiste = true
            
            for categ in (userLogged.categories)
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
                userLogged.addCategoriaGasto(textField.text!)
                
                // adiciona no cloud
                dispatch_async(dispatch_get_main_queue(),{
                    
                    DAOCloudKit().addCategory(userLogged)
                })
            }
        }))
        
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    
    @IBAction func logOut(sender: UIButton) {
        
        // deletar o arquivo plist!!!
        
        //base.logout()
        var data = [String:AnyObject]()
        data["email"] = nil
        data["password"] = nil
        data["name"] = nil
        data["isLogged"] = "loggedOut"
        plist.deleteData(data)
        performSegueWithIdentifier("SettingsToLogin", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SettingsToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
            
        }
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
