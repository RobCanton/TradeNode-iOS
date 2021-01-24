//
//  Double+Extensions.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-17.
//

import Foundation

extension Double {
    var priceFormatted:String {
        if self > 100 {
            return String(format: "%.2f", self)
        }
        if self > 10 {
            return String(format: "%.3f", self)
        }
        if self > 1 {
            return String(format: "%.4f", self)
        } else {
            return String(format: "%.5f", self)
        }
    }
}
