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
    let app = UIApplication.sharedApplication()
    @IBOutlet weak var RS: UILabel!
    @IBOutlet weak var gastos: UILabel!
    @IBOutlet weak var imagemCarteira: UIImageView!
    var items: [NSDictionary] = []
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
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        view.backgroundColor = UIColor.whiteColor()
        gastei.hidden = true
        limite.hidden = true
        totaldisponivel.hidden = true
        totalgastos.hidden = true
        settingsbutton.hidden = true
        RS.hidden = true
        gastos.hidden = true
        imagemCarteira.hidden = true
        self.tabBarController?.tabBar.hidden = true
        
        DAOCloudKit().fetchCategoriesForUser(userLogged)
        DAOCloudKit().fetchGastosFromUser(userLogged)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationSuccessLoad), name: "notificationSuccessLoadUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationErrorLoad), name: "notificationErrorLoadUser", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.actOnNotificationErrorInternet), name: "notificationErrorInternet", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func printaLimite(usuario: User) {
        
        if(userLogged.limiteMes == 0) {
            limite.text = "O limite mensal ainda não foi cadastrado.\nRealize-o nas configurações."
        }
        else {
            limite.text = "Seu limite mensal é de R$ \(usuario.limiteMes)"
        }
    }
    
    @IBAction func botaogastar(sender: UIButton) {
        
        if userLogged.previsaogastosmes(userLogged) > userLogged.limiteMes
        {
            let alertTime = NSDate().dateByAddingTimeInterval(60)
            let notifyAlarm = UILocalNotification()
            
            notifyAlarm.fireDate = alertTime
            notifyAlarm.timeZone = NSTimeZone.defaultTimeZone()
            notifyAlarm.soundName = UILocalNotificationDefaultSoundName
            notifyAlarm.category = "Aviso_Category"
            notifyAlarm.alertTitle = "Cuidado"
            notifyAlarm.alertBody = "Seu limite mensal é R$\(userLogged.limiteMes) e a sua previsão de gastos para o mês é : R$\(userLogged.previsaogastosmes(userLogged).roundToPlaces(2))"
            app.scheduleLocalNotification(notifyAlarm)
        }
        else{
            if userLogged.abaixoDaMedia(userLogged)
            {
                let alertTime = NSDate().dateByAddingTimeInterval(60)
                
                let notifyAlarm = UILocalNotification()
                
                notifyAlarm.fireDate = alertTime
                notifyAlarm.timeZone = NSTimeZone.defaultTimeZone()
                notifyAlarm.soundName = UILocalNotificationDefaultSoundName
                notifyAlarm.category = "Aviso_Category"
                notifyAlarm.alertTitle = "Atenção"
                notifyAlarm.alertBody = "Você está gastando muito hoje.Previsão para o mês: R$\(userLogged.previsaogastosmes(userLogged).roundToPlaces(2)))"
                app.scheduleLocalNotification(notifyAlarm)
            }
        }
        
        
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
        print(userLogged.previsaogastosmes(userLogged))
    }
    
    func actOnNotificationErrorInternet() {
        
        let alert=UIAlertController(title:"Erro", message: "Verifique a sua conexão com a internet, erro ao acessar a Cloud.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alert,animated: true, completion: nil)
        exit(0)
    }
    
    func actOnNotificationErrorLoad()
    {
        let alert=UIAlertController(title:"Erro", message: "Favor verificar se está conectado no iCloud.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alert,animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("entrou na viewWillAppear")
        //  setNotification()
        
        print(executar)
        if(flagLogout) {
            
            print("entrou na viewWillAppear, flagLogout é true")
            self.view.hidden = true
            dismissViewControllerAnimated(false, completion: nil)
        }
            
        else {
            if(executar == true)
            {
                print("Executou appear")
                setView()
            }
        }
    }
    
    func setView()
    {
        executar = false
        var gastosmes:[Gasto]!
        gastosGlobal = userLogged.gastos
        //print(gastosGlobal)
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
            
            print("GASTOS MES:::::::::::::::", gastosmes)
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
            print("VALOR TOTAL MES :::::::::::::: ", self.valorTotalMes)
            if(userLogged.limiteMes != 0)
            {
                self.available = userLogged.limiteMes - self.valorTotalMes
                if(self.available >  0 && self.available >= (0.2 * userLogged.limiteMes) )
                {
                    
                    self.totaldisponivel.text = "Você ainda tem R$ \(self.available) \n para gastar nesse mês"
                    // eamarela = false
                    evermelha = false
                    eazul = true
                }
                else
                {
                    if (self.available > 0 && self.available <= (0.2 * userLogged.limiteMes) )
                    {
                        self.totaldisponivel.text = "Atenção! Você só tem mais \n R$ \(self.available) para gastar nesse mês"
                        //  eamarela = true
                        evermelha = false
                        eazul = true
                    }
                    else
                    {
                        if self.available == 0
                        {
                            self.totaldisponivel.text = "Você atingiu seu limite mensal!"
                            // eamarela = false
                            evermelha = false
                            eazul = true
                        }
                    
                    else
                    {
                        self.totaldisponivel.text = "Você estourou seu limite \n mensal por R$\(self.valorTotalMes - userLogged.limiteMes)"
                        // eamarela = false
                        evermelha = true
                        eazul = false
                    }
                    }
                }
                
                if (evermelha)
                {
                    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
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
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
            }
            
            var arrayCategories = [String]()
            var arrayValor = [String]()
            var total = [String]()
            
            total.append(String(self.valorTotalMes))
            var i = 0
            for _ in userLogged.getGastosHoje()
            {
                arrayCategories.append(userLogged.getGastosHoje()[i].category)
                arrayValor.append(String(userLogged.getGastosHoje()[i].value))
                i+=1
            }
            /*   let item = ["categories": arrayCategories, "valor": arrayValor,"total":total]
             self.items.append(item)
             if let newItems = NSUserDefaults.standardUserDefaults().objectForKey("items") as? [NSDictionary] {
             self.items = newItems
             }
             print(self.items)
             WCSession.defaultSession().transferUserInfo(item)
             */
            if (WCSession.isSupported()) {
                let session = WCSession.defaultSession()
                session.delegate = self
                session.activateSession()
                session.sendMessage(["categorias":[arrayCategories,arrayValor,total]], replyHandler: {(handler) -> Void in print(handler)}, errorHandler: {(error) -> Void in print(#file,error)})
            }
            else
            {
                print("Nao está conectado ao watch")
            }
        }
    }
}