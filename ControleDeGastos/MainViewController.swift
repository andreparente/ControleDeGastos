//
//  MainViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
var executar = false
import WatchConnectivity
class MainViewController: UIViewController,WCSessionDelegate {
    
    @IBOutlet weak var settingsbutton: UIButton!
    
    @IBOutlet weak var gastei: UIButton!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var limite: UILabel!
    @IBOutlet weak var totaldisponivel: UILabel!
    @IBOutlet weak var totalgastos: UILabel!
    @IBOutlet weak var totalDisponivelMes: UILabel!
    
    @IBOutlet weak var RS: UILabel!
    @IBOutlet weak var gastos: UILabel!
    @IBOutlet weak var imagemCarteira: UIImageView!
    
    var available: Double!
    var valortotal: Double = 0.0
    var valorTotalMes: Double = 0.0
    var flagLogout: Bool = false;
    
    override func viewDidLoad() {
        print("Executou Load")
        super.viewDidLoad()
        // Do any additional setup after loading the view
        act.startAnimating()
        valortotal = 0
        valorTotalMes = 0
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        gastei.hidden = true
        limite.hidden = true
        totaldisponivel.hidden = true
        totalgastos.hidden = true
        settingsbutton.hidden = true
        RS.hidden = true
        gastos.hidden = true
        self.tabBarController?.tabBar.hidden = true
        
        DAOCloudKit().fetchCategoriesForUser(userLogged)
        DAOCloudKit().fetchGastosFromUser(userLogged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationSuccessLoad), name: "notificationSuccessLoadUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationErrorLoad), name: "notificationErrorLoadUser", object: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func printaLimite(usuario: User) {
        
        if(userLogged.limiteMes == 0) {
            limite.text = "O limite mensal ainda não foi cadastrado.\nClique em configurações para realizar o cadastro."
        }
        else {
            limite.text = "Seu limite por mês é de R$ \(usuario.limiteMes)."
        }
    }
    @IBAction func botaogastar(sender: UIButton) {
        
    }
    
    @IBAction func botaosettings(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MainToSettings" {
            
            let vc = segue.destinationViewController as! SettingsViewController
            vc.mainVC = segue.sourceViewController as? MainViewController
            
            
        }
    }
    
    func actOnNotificationSuccessLoad()
    {
        setView()
        var arrayCategories = [String]()
        var arrayValor = [String]()
        var i = 0
        for _ in userLogged.gastos
        {
            arrayCategories.append(userLogged.gastos[i].category)
            arrayValor.append(String(userLogged.gastos[i].value))
            i+=1
        }
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            session.sendMessage(["categorias":[arrayCategories,arrayValor]], replyHandler: {(handler) -> Void in print(handler)}, errorHandler: {(error) -> Void in print(#file,error)})
            /* do {
             try  session.updateApplicationContext(["message":[arrayCategories,arrayValor]])
             } catch let error as NSError {
             NSLog("Updating the context failed: " + error.localizedDescription)
             }
             }
             else{
             print("cry")
             }
             */
        }
    }
    func actOnNotificationErrorLoad()
    {
        let alert=UIAlertController(title:"Erro", message: "Erro ao dar fetch no user", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("entrou na viewWillAppear")
        
        
        if(flagLogout) {
            
            print("entrou na viewWillAppear, flagLogout é true")
            self.view.hidden = true
            dismissViewControllerAnimated(false, completion: nil)
        }
        
        if(executar == true)
        {
            print("Executou appear")
            setView()
        }
    }
    
    func setView()
    {
        executar = false
        var gastosmes:[Gasto]!
        gastosGlobal = userLogged.gastos
        self.valorTotalMes = 0
        self.valortotal = 0
        dispatch_async(dispatch_get_main_queue()) {
            
            gastosmes = userLogged.getGastosUltimoMês()
            self.gastei.hidden = false
            self.limite.hidden = false
            self.totaldisponivel.hidden = false
            self.totalgastos.hidden = false
            self.settingsbutton.hidden = false
            self.tabBarController?.tabBar.hidden = false
            self.RS.hidden = false
            self.gastos.hidden = false
            self.imagemCarteira.hidden = false
            self.act.stopAnimating()
            self.printaLimite(userLogged)
            let hoje = NSDate()
            let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: hoje)
            let mesAtual = components.month
            let anoAtual = components.year
            
            for valor in (gastosmes) {
                self.valortotal += valor.value
                let data = valor.date.componentsSeparatedByString("-")
                if(Int(data[1]) == mesAtual && Int(data[0]) == anoAtual) {
                    self.valorTotalMes += valor.value
                }
            }
            // self.totalgastos.text = "Seu total de gastos do mês é: R$ \(self.valorTotalMes)"
            self.totalgastos.text = "\(self.valorTotalMes)"
            self.totaldisponivel.numberOfLines = 2
            
            if(userLogged.limiteMes != 0)
            {
                self.available = userLogged.limiteMes - self.valorTotalMes
                if(self.available >  0 && self.available > (0.2 * userLogged.limiteMes) )
                {
                    self.totaldisponivel.text = "Você ainda tem R$ \(self.available) para gastar nesse mês"
                    eamarela = false
                    evermelha = false
                    eazul = true
                }
                else
                {
                    if (self.available > 0 && self.available < (0.2 * userLogged.limiteMes) )
                    {
                        self.totaldisponivel.text = "Atenção! Você só tem mais R$ \(self.available) para gastar nesse mês"
                        eamarela = true
                        evermelha = false
                        eazul = false
                    }
                    else
                    {
                        self.totaldisponivel.text = "Você estourou seu limite de gastos do mês por R$\(self.valorTotalMes - userLogged.limiteMes)"
                        eamarela = false
                        evermelha = true
                        eazul = false
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
                if (eazul)
                {
                    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
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
