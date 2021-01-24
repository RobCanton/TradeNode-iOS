//
//  DetailHeaderView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation
import UIKit
import SwiftUI

class DetailHeaderView:UIView {
    
    var backdrop:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.Theme.background
        backdrop = UIView()
        self.addSubview(backdrop)
        backdrop.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        backdrop.backgroundColor = UIColor.black
        
//        let itemRow = ItemRow(symbol: "AAPL", name: "Apple Inc")
//        let viewCtrl = UIHostingController(rootView: itemRow)
////
//        self.addSubview(viewCtrl.view)
//        viewCtrl.view.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
//        viewCtrl.view.constraintHeight(to: MinibarView.height)
//        viewCtrl.view.backgroundColor = UIColor.clear
//        viewCtrl.view.backgroundColor = UIColor.clear
    }
}
