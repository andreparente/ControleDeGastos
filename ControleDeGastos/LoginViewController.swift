//
//  LoginViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit


var i=0


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var errosenhas: UILabel!
    @IBOutlet weak var erroemail: UILabel!
    @IBOutlet weak var errocampovazio: UILabel!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var errocadastro: UILabel!
    @IBOutlet weak var background_image: UIImageView!
    
    var usuarioAux: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        i=0
        
        // --------------------------- JOGAR ESSA FUNÇAO NA ACAO DO BOTAO "Logado
        DAOCloudKit().getId() {
            recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
                
                defaults.setObject(userID, forKey: "cloudID")
                userLogged.cloudId = userID
                
            } else {
                print("Fetched iCloudID was nil")
            }
        }
        
        //- --------------------------- --------------------------- --------------------------- ---------------------------
        if DAOCloudKit().cloudAvailable() == false{
            let alert=UIAlertController(title:"iCloud não disponível", message: "Você nāo está logado na sua conta do iCloud, por favor, conecte-se antes de usar este aplicativo!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{(action) -> Void in
                exit(0)
            }))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else if Reachability.isConnectedToNetwork() == false
        {
            let alert=UIAlertController(title:"Internet não disponível", message: "Você nāo está conectado à internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{(action) -> Void in
                exit(0)
            }))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                
                self.performSegueWithIdentifier("LaunchToLogin", sender: self)
            })
        }
        
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnNotificationSuccessLogin), name: "notificationSuccessLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnNotificationErrorPassword), name: "notificationErrorPassword", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.actOnnotificationErrorEmail), name: "notificationErrorEmail", object: nil)
        
        _ = NSBundle.mainBundle().pathForResource("User", ofType: "plist")
        
        //view.backgroundColor = corAzul
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
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
    override func viewWillAppear(animated: Bool) {
        i=0
        
        
        var dict1 = plist.getData()
        if dict1 != nil && dict1!["isLogged"] as! String != "loggedOut" {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.view.hidden = true
                var dict = plist.getData()
                
                userLogged = User(name: dict!["name"] as! String, email: dict!["email"] as! String, password: dict!["password"] as! String)
                self.performSegueWithIdentifier("LoginToMain", sender: self)
                
            })
        }
        senha.text = ""
        self.view.hidden = false
    }
    @IBAction func confirma(sender: UIButton)
    {
        i += 1
        // campos vazios
        if ((mail.text == nil) || senha.text == nil)
        {
            let alert=UIAlertController(title:"Erro", message: "Todos os campos são obrigatórios.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
            return
        }
        
        // email no formato valido
        if isValidEmail(mail.text!) == false
        {
            if(mail.text! != "") {
                let alert=UIAlertController(title:"Erro", message: "E-mail inválido.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
            }
            else {
                let alert=UIAlertController(title:"Erro", message: "Preencha os campos.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
            }
            i=0
            return
        }
        
        if(i==1)
        {
            DAOCloudKit().fetchUserByEmail(mail.text!, password: senha.text!)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LoginToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 0
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
            let alert=UIAlertController(title:"Erro", message: "Senha incorreta.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
        })
    }
    
    func actOnnotificationErrorEmail() {
        
        dispatch_async(dispatch_get_main_queue(),{
            let alert=UIAlertController(title:"Erro", message: "E-mail não cadastrado.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            i=0
        })
        
    }
}
