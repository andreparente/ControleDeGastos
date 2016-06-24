//
//  CadastroViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 3/29/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
var j=0
class CadastroViewController: UIViewController,UITextFieldDelegate,UINavigationBarDelegate{
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmasenha1: UITextField!
    @IBOutlet weak var erroincompleto: UILabel!
    @IBOutlet weak var erromail: UILabel!
    @IBOutlet weak var errosenhas: UILabel!
    @IBOutlet weak var erronome: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        j=0
        // view.backgroundColor = corAzul
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        nome.placeholder = "Nome"
        nome.delegate=self
        nome.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        Email.placeholder = "E-mail"
        Email.delegate=self
        Email.keyboardType = .EmailAddress
        Email.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        senha.placeholder = "Senha"
        senha.delegate=self
        senha.secureTextEntry=true
        senha.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        confirmasenha1.placeholder="Confirmar Senha"
        confirmasenha1.delegate=self
        confirmasenha1.secureTextEntry=true
        confirmasenha1.backgroundColor = UIColor(red: 99/255, green: 170/255, blue: 214/255, alpha: 0.5)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CadastroViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.barTintColor = UIColor.blackColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Tsukushi A Round Gothic", size: 18)!]
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Cadastro"
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(CadastroViewController.btn_clicked(_:)))
        leftButton.tintColor = UIColor.whiteColor()
        leftButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Tsukushi A Round Gothic", size: 15)!], forState: UIControlState.Normal)
        
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroViewController.actOnNotificationFailCadastro), name: "notificationFailCadastro", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CadastroViewController.actOnNotificationSuccessCadastro), name: "notificationSuccessCadastro", object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btn_clicked(sender: UIBarButtonItem) {
        // Do something
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func confirma(sender: UIButton) {
        // verifica se usuario ja existe
        j+=1
        if j==1
        {
            let name=self.nome.text
            let mailsalvo=self.Email.text
            let senhasalva=self.senha.text
            let confirmasenha=self.confirmasenha1.text
            
            // valida preenchimento dos campos
            if (senhasalva!.isEmpty || mailsalvo!.isEmpty||confirmasenha!.isEmpty||name!.isEmpty)
            {
                let alert=UIAlertController(title:"Erro", message: "Preencha todos os campos", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
                j=0
                return
            }
            
            if self.nomevalido(name) == false{
                let alert=UIAlertController(title:"Erro", message: "Nome Errado", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
                j=0
                return
            }
            
            //self.erroincompleto.hidden=true
            
            // valida email
            if isValidEmail(self.Email.text!) == false
            {
                let alert=UIAlertController(title:"Erro", message: "E-mail Inválido", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
                j=0
                return
            }
            //self.erromail.hidden=true
            
            // valida dois campos de senha
            if !(senhasalva == confirmasenha)
            {
                let alert=UIAlertController(title:"Erro", message: "As senhas precisam ser iguais", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alert,animated: true, completion: nil)
                j=0
                return
            }
            
            DAOCloudKit().fetchUserOnlyMail(Email.text!)
        }
    }
    
    func actOnNotificationFailCadastro()
    {
        dispatch_async(dispatch_get_main_queue(),{
            let alert=UIAlertController(title:"Erro", message: "E-mail já cadastrado!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alert,animated: true, completion: nil)
            j=0
        })
        
    }
    func actOnNotificationSuccessCadastro()
    {
        dispatch_async(dispatch_get_main_queue(),{
            
            self.realiza_cadastro()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    func realiza_cadastro() {
        
        let user = User(name: nome.text!, email: Email.text!, password: senha.text!)
        
        //salvando usuário no CloudKit e atribuindo ao usuarioLogado
        DAOCloudKit().saveUser(user)
        
        
    }
    
    func dismissKeyboard() {
        
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func nomevalido(nome:String!) ->(Bool)
    {
        let string1 = Array(nome.characters)
        print(string1)
        
        if(string1.count > 0) {
            for i in 0...string1.count-1
            {
                if string1[i] == " " && i+1<string1.count-1
                {
                    if (string1[i+1]>="A" && string1[i+1] <= "Z") || string1[i+1]>="a" && string1[i+1] <= "z"
                    {
                        return true
                    }
                    else{
                        return false
                    }
                }
            }
        }
        return false
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
