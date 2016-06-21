//
//  LoginViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}
var i=0
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var errosenhas: UILabel!
    @IBOutlet weak var erroemail: UILabel!
    @IBOutlet weak var errocampovazio: UILabel!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var errocadastro: UILabel!
    var usuarioAux: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = NSBundle.mainBundle().pathForResource("User", ofType: "plist")
        
        //view.backgroundColor = corAzul
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        
        mail.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                        attributes:[NSForegroundColorAttributeName: UIColor(red: 52/255, green: 102/255, blue: 139/255, alpha: 1.0)])
        mail.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        
        mail.delegate = self
        mail.keyboardType = .EmailAddress
        senha.attributedPlaceholder = NSAttributedString(string:"Senha",
                                                         attributes:[NSForegroundColorAttributeName: UIColor(red: 52/255, green: 102/255, blue: 139/255, alpha: 1.0)])
        senha.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        senha.secureTextEntry=true
        senha.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func confirma(sender: UIButton)
    {
        i += 1
        // campos vazios
        if ((mail.text == nil) || senha.text == nil)
        {
            let alert=UIAlertController(title:"Erro", message: "Todos os campos são obrigatórios", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
            return
        }
        //errocampovazio.hidden=true
        
        // email no formato valido
        if isValidEmail(mail.text!) == false
        {
            if(mail.text! != "") {
                let alert=UIAlertController(title:"Erro", message: "E-mail Inválido", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
            }
            else {
                let alert=UIAlertController(title:"Erro", message: "Preencha os campos", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
            }
            i=0
            return
        }
        if(i==1)
        {
            DAOCloudKit().fetchUserByEmail(mail.text!, password: senha.text!)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnNotificationSuccessLogin), name: "notificationSuccessLogin", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnNotificationErrorPassword), name: "notificationErrorPassword", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnnotificationErrorEmail), name: "notificationErrorEmail", object: nil)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LoginToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
        }
    }
    
    func dismissKeyboard() {
        
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func cadastro(sender: UIButton) {
        
        performSegueWithIdentifier("LoginToCadastro", sender: self)
        
    }
    
    
    func actOnNotificationSuccessLogin() {
        
        // faz o segue
        dispatch_async(dispatch_get_main_queue(),{
            
            var data = [String:AnyObject]()
            data["email"] = self.mail.text!
            data["password"] = self.senha.text!
            data["name"] = userLogged.name
            data["isLogged"] = "isLogged"
            plist.saveData(data)
            i=0;
            self.performSegueWithIdentifier("LoginToMain", sender: self)
        })
    }
    
    func actOnNotificationErrorPassword() {
        
        dispatch_async(dispatch_get_main_queue(),{
            let alert=UIAlertController(title:"Erro", message: "Senha Incorreta", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
        })
    }
    
    func actOnnotificationErrorEmail() {
        
        dispatch_async(dispatch_get_main_queue(),{
            let alert=UIAlertController(title:"Erro", message: "E-mail não cadastrado", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
        })
        
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
