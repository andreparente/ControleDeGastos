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

    @IBOutlet weak var erroemail: UILabel!
    @IBOutlet weak var errocampovazio: UILabel!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var senha: UITextField!
    var usuarioAux: Usuario?
    
        override func viewDidLoad() {
        super.viewDidLoad()
        nome.placeholder="Nome"
        nome.delegate = self
        mail.placeholder="Email"
        mail.delegate = self
        senha.placeholder="Senha"
        senha.secureTextEntry=true
        senha.delegate = self
        errocampovazio.hidden=true
        errocampovazio.text="Todos os campos são obrigatórios"
        erroemail.hidden=true
        erroemail.text="Email inválido"
        
    }
    
    @IBAction func confirma(sender: UIButton)
{
    if (nome.text!.isEmpty || (mail.text!.isEmpty) || senha.text!.isEmpty)
    {
        errocampovazio.hidden=false
    }
    else
    {
    errocampovazio.hidden=true
        if isValidEmail(mail.text!) == false
        {
        erroemail.hidden=false
        }
        else
        {
        erroemail.hidden=true
            usuarioAux = Usuario(nome: nome.text!,email: mail.text!,senha: senha.text!)
            usuarioLogado = usuarioAux
        performSegueWithIdentifier("LoginToMain", sender: self)
        }
    }
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LoginToMain" {
        
        let vc = segue.destinationViewController as! UITabBarController
        vc.selectedIndex = 1
        
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        view.endEditing(true)
        
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
