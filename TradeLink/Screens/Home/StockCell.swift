//
//  StockCell.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation
import UIKit
import SwiftUI

class StockCell:UITableViewCell {
    
    let symbolLabel:UILabel
    let nameLabel:UILabel
    let priceLabel:UILabel
    let changeLabel:UILabel
    let chartView:ChartView
    let chartViewModel:ChartViewModel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        symbolLabel = UILabel()
        nameLabel = UILabel()
        priceLabel = UILabel()
        changeLabel = UILabel()
        chartViewModel = ChartViewModel()
        chartView = ChartView(viewModel: chartViewModel)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        backgroundColor = UIColor.Theme.background2
        //contentView.backgroundColor = UIColor.Theme.background2
        
        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 4.0
        
        contentView.addSubview(titleStack)
        titleStack.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: true)
        titleStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33).isActive = true
        
        symbolLabel.text = "AAPL"
        symbolLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        titleStack.addArrangedSubview(symbolLabel)
        nameLabel.text = "Apple Inc"
        nameLabel.textColor = .secondaryLabel
        nameLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        
        titleStack.addArrangedSubview(nameLabel)
        
        let priceStack = UIStackView()
        priceStack.axis = .vertical
        priceStack.spacing = 4.0
        priceStack.alignment = .trailing
        
        contentView.addSubview(priceStack)
        priceStack.constraintToSuperview(12, nil, 12, 12, ignoreSafeArea: true)
        priceStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33).isActive = true
        
        priceLabel.text = "17.20"
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .semibold)
        
        priceStack.addArrangedSubview(priceLabel)
        
        changeLabel.text = "+6.20"
        changeLabel.textColor = UIColor(hex: "02D277")
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 13.0, weight: .regular)
        
        priceStack.addArrangedSubview(changeLabel)
        
        let host = UIHostingController(rootView: chartView)
        contentView.addSubview(host.view)
        host.view.constraintToSuperview(12, nil, 12, nil, ignoreSafeArea: true)
        host.view.leadingAnchor.constraint(equalTo: titleStack.trailingAnchor, constant: 8).isActive = true
        host.view.trailingAnchor.constraint(equalTo: priceStack.leadingAnchor, constant: 8).isActive = true
        host.view.backgroundColor = UIColor.clear
        host.view.clipsToBounds = true
    }
    
    func setup(item:Item) {
        item.setDelegate(key: "home", self)
        symbolLabel.text = item.symbol
        nameLabel.text = item.name

        if let price = item.trades.last?.price {
            priceLabel.text = price.priceFormatted
        } else {
            priceLabel.text = "-"
        }
        
        
        
        
    }
    
    
}

extension StockCell: ItemDelegate {
    func didUpdate(_ item:Item) {
        if let price = item.trades.last?.price {
            priceLabel.text = price.priceFormatted
        } else {
            priceLabel.text = "-"
        }
        
        chartViewModel.setTrades(item.trades)
    }
}
