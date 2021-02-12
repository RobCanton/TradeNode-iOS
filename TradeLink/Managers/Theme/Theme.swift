//
//  ThemeConstants.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-10.
//

import Foundation
import UIKit


struct Theme {
    let id:String
    let statusBarStyle:UIStatusBarStyle
    let background:UIColor
    let secondaryBackground:UIColor
    let chartBackground:UIColor
    let separator:UIColor
    let label:UIColor
    let secondaryLabel:UIColor
    
    let positiveLabel:UIColor
    let negativeLabel:UIColor
    let neutralLabel:UIColor
}

extension Theme {
    
    static var current:Theme = dark
    
    static let dark = Theme(id: "dark",
                            statusBarStyle: .lightContent,
                            background: UIColor(white: 0.04, alpha: 1.0),
                              secondaryBackground: UIColor(white: 0.06, alpha: 1.0),
                              chartBackground: UIColor.black,
                              separator: UIColor(white: 0.1, alpha: 1.0),
                              label: UIColor.white,
                              secondaryLabel: UIColor(white: 0.5, alpha: 1.0),
                              positiveLabel: UIColor(hex: "00CC8C"),
                              negativeLabel: UIColor(hex: "E7255C"),//UIColor(hex: "FE3653"),
                              neutralLabel: UIColor(white: 0.5, alpha: 1.0))
}

extension UIColor {
    static var theme:Theme {
        return Theme.current
    }
}

//extension UIColor {
//    struct Theme {
//        static let background = UIColor(hex: "141C23")//"202020")
//        static let background2 = UIColor(hex: "0B0F13")//"181818")
//    }
//}
//
