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
        
        // valida preenchimento dos campos
        if (senhasalva!.isEmpty || mailsalvo!.isEmpty||confirmasenha!.isEmpty||name!.isEmpty)
        {
            erroincompleto.hidden=false
            return
        }
        erroincompleto.hidden=true
        
        // valida email
        if isValidEmail(Email.text!) == false
        {
            erromail.hidden=false
            return
        }
        erromail.hidden=true
        
        // valida dois campos de senha
        if !(senhasalva == confirmasenha)
        {
            errosenhas.hidden=false
            return
        }
        
        // verifica se usuario ja existe
        if (usuarioJaExiste()) {
            // TODO: avisar o usuario
            print("email ja cadastrado!")
            return
        }
        
        // realizando o cadastro:
        let usuario = Usuario(nome: name!, email: mailsalvo!, senha: senhasalva!)
        // adiciona usuario na lista de usuarios da RAM
        base.listaUsuarios.append(usuario)
        // adiciona usuario na lista de usuarios do disco
        base.adicionarUsuario(usuario)
        // adiciona o usuario na entrada ultimoUsuario da base
        base.salvarUltimoUsuario(usuario)
        // configura o usuarioLogado para ser o de agora
        base.usuarioLogado = usuario
        
        performSegueWithIdentifier("CadastroToLogin", sender: self)
    }
    
    func usuarioJaExiste () -> Bool {
        let i = base.indiceUsuarioPorEmail(Email.text!)
        return i != -1
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
