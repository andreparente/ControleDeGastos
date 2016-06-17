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


    @IBOutlet var totalValue: WKInterfaceLabel!
    
    var auxiliar: Double = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
    
    @IBAction func Tapped1() {
        totalValue.setText(<#T##text: String?##String?#>)
    }
    
    @IBAction func Tapped2() {
    }
    @IBAction func Tapped3() {
    }
    @IBAction func Tapped4() {
    }
    @IBAction func Tapped5() {
    }
    @IBAction func Tapped6() {
    }
    @IBAction func Tapped7() {
    }
    @IBAction func Tapped8() {
    }
    @IBAction func Tapped9() {
    }
    @IBAction func Tapped0() {
    }
    @IBAction func TappedDot() {
    }
    @IBAction func TappedNext() {
    }
    @IBAction func TappedClear() {
    }
}
