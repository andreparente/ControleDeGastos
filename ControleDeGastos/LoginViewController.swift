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

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var errosenha: UILabel!
    @IBOutlet weak var erroemail: UILabel!
    @IBOutlet weak var errocampovazio: UILabel!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var senha: UITextField!
    var usuarioAux: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        mail.attributedPlaceholder = NSAttributedString(string:"Email",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        mail.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        mail.delegate = self
        mail.keyboardType = .EmailAddress
        senha.attributedPlaceholder = NSAttributedString(string:"Senha",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        senha.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        senha.secureTextEntry=true
        senha.delegate = self
        errocampovazio.hidden=true
        errocampovazio.text="Todos os campos são obrigatórios"
        erroemail.hidden=true
        erroemail.text="Email inválido"
//        errosenha.hidden=true
//        errosenha.text="Senha errada" // falta adicionar na storyboard
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        /*
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        */
    }

    @IBAction func confirma(sender: UIButton)
    {
        // campos vazios
        if ((mail.text!.isEmpty) || senha.text!.isEmpty)
        {
            errocampovazio.hidden=false
            return
        }
        errocampovazio.hidden=true
        
        // email no formato valido e existente na base
        let indUsuario = base.indiceUsuarioPorEmail(mail.text!)
        if isValidEmail(mail.text!) == false || indUsuario == -1
        {
            erroemail.hidden=false
            return
        }
        erroemail.hidden=true
        
        // senha valida
        if base.listaUsuarios[indUsuario].senha != senha.text! {
            //errosenha.hidden=false // descomentar depois de adicionar na storyboard
            return
        }
        
        // faz o login
        let usuario = base.listaUsuarios[indUsuario]
        base.login(usuario)
        
        // faz o segue
        performSegueWithIdentifier("LoginToMain", sender: self)
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
