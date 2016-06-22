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

    var outro = InterfaceControllerTable()
    @IBOutlet var total: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        super.willActivate()
    }
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        categorias.removeAll()
        valor.removeAll()
        let text = message["categorias"] as! [[String]]
        var j = 0
        var i = 0
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
        outro.myTable.setNumberOfRows(valor.count, withRowType: "cell")
        for(index,item) in valor.enumerate(){
            let namescontroller = outro.myTable.rowControllerAtIndex(index) as! MyRow
            namescontroller.label1.setText(item)
            namescontroller.labelcateg.setText(categorias[i])
            i+=1
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func toTable() {
    }

}
