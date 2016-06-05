//
//  MainViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var limite: UILabel!
    @IBOutlet weak var totaldisponivel: UILabel!
    @IBOutlet weak var totalgastos: UILabel!
    @IBOutlet weak var totalDisponivelMes: UILabel!
    var available: Double!
    var totalgastos1:Double!
    var valortotal: Double = 0.0
    var valorTotalMes: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userPlistDic = plist.getData()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            DAOCloudKit().fetchUser(userLogged)
            DAOCloudKit().fetchGastosFromUser(userLogged)

        }
        
        print ("login feito com o usuario \(userLogged.name), de email \(userLogged.email)")
        print("no plist temos o nome: \(userPlistDic!["name"]), e o email: \(userPlistDic!["email"])")
        
        view.backgroundColor = corAzul
        printaLimite(userLogged)
        let hoje = NSDate()
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
        let mesAtual = components.month
        let anoAtual = components.year
        for valor in (userLogged.gastos) {
            print(userLogged.gastos)
            valortotal += valor.value
            
        }
        print(valortotal)
        for valor in (userLogged.gastos) {
            let data = valor.date.componentsSeparatedByString("-")
            if(Int(data[1]) == mesAtual && Int(data[0]) == anoAtual) {
                valorTotalMes += valor.value
            }
        }
        
        totalgastos.text = "Seu total de gastos é: R$ \(valortotal)"
        totaldisponivel.numberOfLines = 2
        
        if(userLogged.limiteMes != 0)
        {
            available = userLogged.limiteMes - valorTotalMes
            if(available >= 100 && available > (0.2 * userLogged.limiteMes) )
            {
                totaldisponivel.text = "Você ainda tem R$ \(available) para gastar nesse mês"
                eamarela = false
                evermelha = false
            }
            else
            {
                if (available > 0 && available < (0.2 * userLogged.limiteMes) )
                {
                    totaldisponivel.text = "Atenção! Você só tem mais R$ \(available) para gastar nesse mês"
                    eamarela = true
                    evermelha = false
                }
                else
                {
                    totaldisponivel.text = "Você estourou seu limite de gastos do mês por R$\(valorTotalMes - userLogged.limiteMes)"
                    eamarela = false
                    evermelha = true
                }
            }
            if (eamarela)
            {
                view.backgroundColor = corAmarela
            }
            if (evermelha)
            {
                view.backgroundColor = corVermelha
            }
            
            totaldisponivel.hidden=false
        }
        else
        {
            totaldisponivel.hidden=true
        }
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

    @IBAction func botaogastar(sender: UIButton) {
        totalgastos1 = valortotal
    }
    
    @IBAction func botaosettings(sender: UIButton) {
        totalgastos1 = valortotal
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
