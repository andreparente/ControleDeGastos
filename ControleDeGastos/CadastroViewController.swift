//
//  CadastroViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 3/29/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class CadastroViewController: UIViewController,UITextFieldDelegate,UINavigationBarDelegate{
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmasenha1: UITextField!
    @IBOutlet weak var erroincompleto: UILabel!
    @IBOutlet weak var erromail: UILabel!
    @IBOutlet weak var errosenhas: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        nome.placeholder = "nome"
        nome.delegate=self
        Email.placeholder = "Email"
        Email.delegate=self
        Email.keyboardType = .EmailAddress
        senha.placeholder = "Senha"
        senha.delegate=self
        senha.secureTextEntry=true
        confirmasenha1.placeholder="Confirma Senha"
        confirmasenha1.delegate=self
        confirmasenha1.secureTextEntry=true
        erroincompleto.hidden=true
        erroincompleto.text="Todos os dados são obrigatórios"
        erromail.hidden=true
        erromail.text="E-mail inválido"
        errosenhas.hidden=true
        errosenhas.text="Senhas não são iguais"/*
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)*/
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Cadastro"
        /*
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(GastoManualViewController.btn_clicked(_:)))
        
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        */
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func btn_clicked(sender: UIBarButtonItem) {
        // Do something
        performSegueWithIdentifier("CadastroToLogin", sender: self)
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
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
