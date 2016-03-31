//
//  SettingsViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationBarDelegate{
    var field:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Settings"
        
        // Create left and right button for navigation item
//        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(SettingsViewController.btn_clicked(_:)))

        
        // Create two buttons for the navigation item
//        navigationItem.leftBarButtonItem = leftButton
        
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
        let alert=UIAlertController(title:" Seu limite e:\(base.usuarioLogado!.getLimiteMes())", message: "Mude seu limite abaixo:", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (field) -> Void in
            field.placeholder = "Insira seu limite"})
        alert.addAction(UIAlertAction(title:"Cancelar",style: UIAlertActionStyle.Cancel,handler: nil))
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{ (action) -> Void in
        let textField = alert.textFields![0] as UITextField
        print("Text field: \(textField.text)")
        base.usuarioLogado?.setLimiteMes(Int(textField.text!)!)
    }))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    func btn_clicked(sender: UIBarButtonItem) {
        // Do something
        performSegueWithIdentifier("SettingsToMain", sender: self)
    }
    @IBAction func categoria(sender: UIButton) {
        let alert=UIAlertController(title:"Categoria", message: "Insira uma nova categoria abaixo", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({ (field) -> Void in
            field.placeholder = "Insira nova categoria"})
        alert.addAction(UIAlertAction(title:"Cancelar",style: UIAlertActionStyle.Cancel,handler: nil))
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{ (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            for usuario in (base.usuarioLogado?.categoriasGastos)!
                {
                    if textField.text == usuario
                    {
                        let alert2=UIAlertController(title:"Erro", message: "Categoria já existe", preferredStyle: UIAlertControllerStyle.Alert)
                        alert2.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Cancel,handler: nil))
                        self.presentViewController(alert2,animated: true, completion: nil)
                    }
                }
        }))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    @IBAction func mudaremail(sender: UIButton) {
    }
    @IBAction func logOut(sender: UIButton) {
        base.usuarioLogado=nil
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
