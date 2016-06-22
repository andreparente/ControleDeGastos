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
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let text = message["categorias"] as! [[String]]
        print(text)
        var valor = [String]()
        var categorias = [String]()
        var i = 0
        var j = 0
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
        print(categorias)
        print(valor)
        self.myTable.setNumberOfRows(valor.count, withRowType: "cell")
        for(index,item) in valor.enumerate(){
            let namescontroller = myTable.rowControllerAtIndex(index) as! MyRow
            namescontroller.label1.setText(item)
            namescontroller.labelcateg.setText(categorias[i])
            i+=1
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}


