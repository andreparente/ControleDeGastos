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

extension NSDate {
    func changeDaysBy(days : Int) -> NSDate {
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        dateComponents.day = days
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
    }
}

extension NSDate {
    func createFromDate(dia: Int, mes: Int, ano: Int) -> NSDate {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        components.day = dia
        components.month = mes
        components.year = ano
        let timeInterval = (NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(components)!.timeIntervalSince1970)!
        return NSDate(timeIntervalSince1970: timeInterval)
    }
}