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
        let text = message["message"] as! [String]
        print(text)
       // var names : [String] = [text]
        var names = [String]()
        var i = 0
        for _ in text
        {
            names.append(text[i])
            i+=1
        }
        print(names)
        self.myTable.setNumberOfRows(names.count, withRowType: "cell")
        for(index,item) in names.enumerate(){
            let namescontroller = myTable.rowControllerAtIndex(index) as! MyRow
            namescontroller.label1.setText(item)
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


