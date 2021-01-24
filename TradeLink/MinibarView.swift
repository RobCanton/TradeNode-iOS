//
//  MinibarView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation
import UIKit
import SwiftUI

class MinibarView:UIView {
    
    static let height:CGFloat = 64
    
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
        self.constraintHeight(to: Self.height)
        
        let itemRow = ItemRow(item: MarketItem(from: SymbolSearchResult(s: "", b: "", n: "", x: "", c: 0)))
        let viewCtrl = UIHostingController(rootView: itemRow)
//
        self.addSubview(viewCtrl.view)
        viewCtrl.view.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        viewCtrl.view.backgroundColor = UIColor.clear
    }
}
