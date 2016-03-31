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
    @IBOutlet weak var totalgastos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print ("login feito com o usuario \(base.usuarioLogado!.nome), de email \(base.usuarioLogado!.email)")
        
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        var valortotal:Int = 0
        printaLimite(base.usuarioLogado!)
        for valor in (base.usuarioLogado?.gastos)!
        {
            valortotal += valor.valor
        }
        totalgastos.text = "Seu total de gastos é: \(valortotal)"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printaLimite(usuario: Usuario) {
        if(usuario.limiteMes == 0) {
            limite.text = "Você não disponibilizou o limite por mês"
        }
        else {
            limite.text = "Seu limite é \(usuario.limiteMes)"
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
