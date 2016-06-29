//
//  NotificationController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 6/24/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet var labeldescricao: WKInterfaceLabel!
    @IBOutlet var labeltitulo: WKInterfaceLabel!
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
            if localNotification.alertTitle == "Cuidado" {
                labeltitulo.setText("Cuidado")
                labeldescricao.setText("Nesse ritmo seu limite vai estourar antes do fim do mês.")
            }
            
            if localNotification.alertTitle == "Atenção" {
                labeltitulo.setText("Atenção")
                labeldescricao.setText("Você gastou muito hoje!")
            }
            
            completionHandler(.Custom)
        }

    
    /*
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.Custom)
    }
    */
}
