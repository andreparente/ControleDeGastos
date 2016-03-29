//
//  CadastroViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 3/29/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmasenha1: UITextField!
    @IBOutlet weak var erroincompleto: UILabel!
    @IBOutlet weak var erromail: UILabel!
    @IBOutlet weak var errosenhas: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nome.placeholder = "nome"
        Email.placeholder = "Email"
        senha.placeholder = "Senha"
        confirmasenha1.placeholder="Confirma Senha"
        erroincompleto.hidden=true
        erroincompleto.text="Todos os dados são obrigatórios"
        erromail.hidden=true
        erromail.text="E-mail inválido"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirma(sender: UIButton) {
        let name=nome.text
        let mailsalvo=Email.text
        let senhasalva=senha.text
        let confirmasenha=confirmasenha1.text
        if (senhasalva!.isEmpty || mailsalvo!.isEmpty||confirmasenha!.isEmpty||name!.isEmpty)
        {
            erroincompleto.hidden=false
        }
        else
        {
            erroincompleto.hidden=true
            if isValidEmail(Email.text!) == false
            {
                erromail.hidden=false
            }
            else
            {
                erromail.hidden=true
                if senhasalva == confirmasenha
                {
                    performSegueWithIdentifier("CadastroToLogin", sender: self)
                }
                else
                {
                    errosenhas.hidden=false
                }
            }
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
