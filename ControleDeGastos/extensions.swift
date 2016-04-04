//
//  extensions.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 4/4/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

extension String {
    func toDouble() -> Double? {
        if (self == "") {
            return 0.0
        }
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}