//
//  String+Currency.swift
//  Poynt_iOS_SDK
//
//  Created by Eric McConkie on 3/21/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import Foundation
extension String {

    static func currencyForFloat(_ amnt:Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let amt = amnt / 100.0
        if let val = formatter.string(from: NSNumber(value: amt as Float)) as String? {
            return val
        }
        return ""
    }
}
