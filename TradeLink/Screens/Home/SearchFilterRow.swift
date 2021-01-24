//
//  SearchFilterRow.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-15.
//

import Foundation
import UIKit

class SearchFilterRow:UIView {
    
    var stackRow:UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.Theme.background2
        //constraintHeight(to: 44)
        
        stackRow = UIStackView()
        stackRow.axis = .horizontal
        stackRow.spacing = 10.0
        stackRow.distribution = .fillEqually
        stackRow.constraintHeight(to: 30)
        
        self.addSubview(stackRow)
        stackRow.constraintToSuperview(8, 16, 8, 16, ignoreSafeArea: true)
        
        let titles = ["Stocks", "Forex", "Crypto"]
        for title in titles {
            let button = createButton(title: title)
            stackRow.addArrangedSubview(button)
        }
        
    }
    
    func createButton(title:String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderWidth = 2 / UIScreen.main.scale
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        
        button.layer.cornerRadius = 30/2
        return button
    }
}
