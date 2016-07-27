//
//  String+Currency.swift
//  Poynt_iOS_SDK
//
//  Created by Eric McConkie on 3/21/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import Foundation
extension String {

    static func currencyForFloat(amnt:Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle

        let amt = amnt / 100.0
        if let val = formatter.stringFromNumber(NSNumber(float: amt)) as String? {
            return val
        }
        return ""
    }
}