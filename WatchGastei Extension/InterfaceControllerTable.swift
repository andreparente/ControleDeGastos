//
//  InterfaceControllerTable.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 6/22/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
var valor = [String]()
var categorias = [String]()
var totalmes = Double()
class InterfaceControllerTable: WKInterfaceController,WCSessionDelegate {

    @IBOutlet var myTable: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self 
            session.activateSession()
        }
        else{
            print("já era")
        }
        

        // Configure interface objects here.
    }

    override func willActivate() {
        var i = 0
        self.myTable.setNumberOfRows(valor.count, withRowType: "cell")
        for(index,item) in valor.enumerate(){
            let namescontroller = myTable.rowControllerAtIndex(index) as! MyRow
            namescontroller.label1.setText(item)
            if categorias.count != 0
            {
            namescontroller.labelcateg.setText(categorias[i])
            i+=1
            namescontroller.labelcateg.setHidden(false)
            }
            else{
                namescontroller.labelcateg.setHidden(true)
            }
        }
        super.willActivate()
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        categorias.removeAll()
        valor.removeAll()
        let text = message["categorias"] as! [[String]]
        var j = 0
        var i = 0
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
        defaults.setObject(text[0], forKey: "categories")
        defaults.setObject(text[1], forKey: "valor")
        defaults.setDouble(Double(text[2][0])!, forKey: "total")
        print(categorias)
        self.myTable.setNumberOfRows(valor.count, withRowType: "cell")
        for(index,item) in valor.enumerate(){
            let namescontroller = myTable.rowControllerAtIndex(index) as! MyRow
            namescontroller.label1.setText(item)
            if categorias.count != 0
            {
                namescontroller.labelcateg.setText(categorias[i])
                i+=1
                namescontroller.labelcateg.setHidden(false)
            }
            else{
                namescontroller.labelcateg.setHidden(true)
            }
        }
        
    }
        override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}


