//
//  Manager+Extensions.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-16.
//

import Foundation

/*
    "AAA"-prefix is required to prevent compile errors
    so that this is compiled before all other files
 */
extension NSObject {
    func log(_ msg: String) {
        NSLog("\(NSStringFromClass(type(of: self))) \(msg)")
    }
}

