//
//  InterfaceController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 6/22/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {

    @IBOutlet var total: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            //let session2 = WCSession.activateSession(<#T##WCSession#>)
            session.delegate = self
            session.activateSession()
        }
        else{
            print("já era")
        }

        // Configure interface objects here.
    }
    override func willActivate() {
        //setNotification()
       /* var dict1 = plist.getData()
        if dict1 != nil{
        valor = dict1!["Valores"] as! Array
        categorias = dict1!["Categorias"] as! Array
        totalmes = dict1!["Total"] as! Double
        }
 */
        super.willActivate()
        total.setText("Total do mes:\(totalmes)")
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        categorias.removeAll()
        valor.removeAll()
        let text = message["categorias"] as! [[String]]
        var j = 0
        print(text[0].count)
        print(text[1].count)
        if text[0].count != 0
        {
        for _ in j...text[0].count - 1
        {
            categorias.append(text[0][j])
            j+=1
        }
        j=0
        for _ in j...text[1].count - 1
        {
            valor.append(text[1][j])
            j+=1
        }
        }
        else
        {
            valor.append("Sem gastos hoje")
        }
        totalmes = Double(text[2][0])!
        total.setText("Total do mes:\(totalmes)")
        /*var data = [String:AnyObject]()
        data["Total"] = Double(text[2][0])!
        data["Categorias"] = text[0][0]
        data["Valores"] = text[1][0]
        plist.saveData(data)
 */
        print(categorias)
        print(valor)
        
    
}

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func toTable() {
    }
   }
