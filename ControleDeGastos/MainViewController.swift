//
//  MainViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
var executar = false
class MainViewController: UIViewController {
    
    @IBOutlet weak var settingsbutton: UIButton!
    
    @IBOutlet weak var gastei: UIButton!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var limite: UILabel!
    @IBOutlet weak var totaldisponivel: UILabel!
    @IBOutlet weak var totalgastos: UILabel!
    @IBOutlet weak var totalDisponivelMes: UILabel!
    var available: Double!
    var totalgastos1:Double!
    var valortotal: Double = 0.0
    var valorTotalMes: Double = 0.0 /*{ didSet {
        totalDisponivelMes.text = String(valorTotalMes)
        }
    }*/
        override func viewDidLoad() {
        super.viewDidLoad()
        act.startAnimating()
        //view.hidden = true
        gastei.hidden = true
        limite.hidden = true
        totaldisponivel.hidden=true
        totalgastos.hidden = true
        settingsbutton.hidden = true
        
        let userPlistDic = plist.getData()
        DAOCloudKit().fetchUser(userLogged)
        DAOCloudKit().fetchGastosFromUser(userLogged)
       // DAOCloudKit().fetchLimitFromUser(userLogged)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationSuccessLoad), name: "notificationSuccessLoadUser", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationErrorLoad), name: "notificationErrorLoadUser", object: nil)
        print ("login feito com o usuario \(userLogged.name), de email \(userLogged.email)")
        print("no plist temos o nome: \(userPlistDic!["name"]), e o email: \(userPlistDic!["email"])")
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printaLimite(usuario: User) {
        if(userLogged.limiteMes == 0) {
            limite.text = "O limite mensal ainda não foi cadastrado. \n Clique em configuraçōes para realizar o cadastro"
        }
        else {
            limite.text = "Seu limite por mês é de R$ \(usuario.limiteMes)"
        }
    }
    
    func fazisso()
    {
        print(userLogged.getCategorias())
        print("BAD")
        var gastosmes:[Gasto]!
        dispatch_async(dispatch_get_main_queue()) {
            gastosmes = userLogged.getGastosUltimoMês()
            self.gastei.hidden = false
            self.limite.hidden = false
            self.totaldisponivel.hidden=false
            self.totalgastos.hidden = false
            // self.totalDisponivelMes.hidden = false
            self.settingsbutton.hidden = false
            self.act.stopAnimating()
            self.view.hidden = false
            self.view.backgroundColor = corAzul
            self.printaLimite(userLogged)
            let hoje = NSDate()
            let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
            let mesAtual = components.month
            let anoAtual = components.year
            for valor in (gastosmes) {
                self.valortotal += valor.value
                
            }
            for valor in (gastosmes) {
                let data = valor.date.componentsSeparatedByString("-")
                if(Int(data[1]) == mesAtual && Int(data[0]) == anoAtual) {
                    self.valorTotalMes += valor.value
                }
            }
            
            self.totalgastos.text = "Seu total de gastos do mês é: R$ \(self.valortotal)"
            self.totaldisponivel.numberOfLines = 2
            
            if(userLogged.limiteMes != 0)
            {
                self.available = userLogged.limiteMes - self.valorTotalMes
                if(self.available >= 100 && self.available > (0.2 * userLogged.limiteMes) )
                {
                    self.totaldisponivel.text = "Você ainda tem R$ \(self.available) para gastar nesse mês"
                    eamarela = false
                    evermelha = false
                }
                else
                {
                    if (self.available > 0 && self.available < (0.2 * userLogged.limiteMes) )
                    {
                        self.totaldisponivel.text = "Atenção! Você só tem mais R$ \(self.available) para gastar nesse mês"
                        eamarela = true
                        evermelha = false
                    }
                    else
                    {
                        self.totaldisponivel.text = "Você estourou seu limite de gastos do mês por R$\(self.valorTotalMes - userLogged.limiteMes)"
                        eamarela = false
                        evermelha = true
                    }
                }
                if (eamarela)
                {
                    self.view.backgroundColor = corAmarela
                }
                if (evermelha)
                {
                    self.view.backgroundColor = corVermelha
                }
                
                self.totaldisponivel.hidden=false
            }
            else
            {
                self.totaldisponivel.hidden=true
            }
        }
    }

    @IBAction func botaogastar(sender: UIButton) {
        totalgastos1 = valortotal
    }
    
    @IBAction func botaosettings(sender: UIButton) {
        totalgastos1 = valortotal
    }
    func actOnNotificationSuccessLoad()
    {
        fazisso()
    }
     func actOnNotificationErrorLoad()
     {
        let alert=UIAlertController(title:"Erro", message: "Erro ao dar fetch no user", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alert,animated: true, completion: nil)
     }
    
    override func viewWillAppear(animated: Bool) {
        print("Oi main")
        if(executar == true)
        {
            valortotal = 0
            valorTotalMes = 0
            self.gastei.hidden = false
            self.limite.hidden = false
            self.totaldisponivel.hidden=false
            self.totalgastos.hidden = false
            // self.totalDisponivelMes.hidden = false
            self.settingsbutton.hidden = false
            self.act.stopAnimating()
            self.view.hidden = false
            self.view.backgroundColor = corAzul
            self.printaLimite(userLogged)
            let hoje = NSDate()
            let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
            let mesAtual = components.month
            let anoAtual = components.year
            for valor in (userLogged.gastos) {
                self.valortotal += valor.value
                
            }
            for valor in (userLogged.gastos) {
                let data = valor.date.componentsSeparatedByString("-")
                if(Int(data[1]) == mesAtual && Int(data[0]) == anoAtual) {
                    self.valorTotalMes += valor.value
                }
            }
            
            self.totalgastos.text = "Seu total de gastos do mês é: R$ \(self.valorTotalMes)"
            self.totaldisponivel.numberOfLines = 2
            
            if(userLogged.limiteMes != 0)
            {
                self.available = userLogged.limiteMes - self.valorTotalMes
                if(self.available >= 100 && self.available > (0.2 * userLogged.limiteMes) )
                {
                    self.totaldisponivel.text = "Você ainda tem R$ \(self.available) para gastar nesse mês"
                    eamarela = false
                    evermelha = false
                }
                else
                {
                    if (self.available > 0 && self.available < (0.2 * userLogged.limiteMes) )
                    {
                        self.totaldisponivel.text = "Atenção! Você só tem mais R$ \(self.available) para gastar nesse mês"
                        eamarela = true
                        evermelha = false
                    }
                    else
                    {
                        self.totaldisponivel.text = "Você estourou seu limite de gastos do mês por R$\(self.valorTotalMes - userLogged.limiteMes)"
                        eamarela = false
                        evermelha = true
                    }
                }
                if (eamarela)
                {
                    self.view.backgroundColor = corAmarela
                }
                if (evermelha)
                {
                    self.view.backgroundColor = corVermelha
                }
                
                self.totaldisponivel.hidden=false
            }
            else
            {
                self.totaldisponivel.hidden=true
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

