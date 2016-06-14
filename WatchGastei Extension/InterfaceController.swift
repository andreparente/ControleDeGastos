//
//  InterfaceController.swift
//  WatchGastei Extension
//
//  Created by Felipe Viberti on 6/14/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var myLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let textChoices :[String] =  ["1","10","15"]
        presentTextInputControllerWithSuggestions(textChoices,allowedInputMode: WKTextInputMode.Plain,completion: {(results) -> Void in
            if results != nil && results!.count > 0 { //selection made
               // let aResult = results?[0] as? String{
                 //   self.myLabel.setText(aResult)
                //}
            }
        })
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

}
