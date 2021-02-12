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
    
    weak var item:Item?
    
    
    
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
        backgroundColor = UIColor.theme.background
        //contentView.backgroundColor = UIColor.Theme.background2
        
        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 4.0
        
        contentView.addSubview(titleStack)
        titleStack.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: true)
        titleStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38).isActive = true
        
        symbolLabel.text = "AAPL"
        symbolLabel.textColor = UIColor.theme.label
        symbolLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        titleStack.addArrangedSubview(symbolLabel)
        nameLabel.text = "Apple Inc"
        nameLabel.textColor = UIColor.theme.secondaryLabel
        nameLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        
        titleStack.addArrangedSubview(nameLabel)
        
        let priceStack = UIStackView()
        priceStack.axis = .vertical
        priceStack.spacing = 4.0
        priceStack.alignment = .trailing
        
        contentView.addSubview(priceStack)
        priceStack.constraintToSuperview(12, nil, 12, 12, ignoreSafeArea: true)
        priceStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38).isActive = true
        
        priceLabel.text = "17.20"
        priceLabel.textColor = UIColor.theme.label
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .semibold)
        
        priceStack.addArrangedSubview(priceLabel)
        
        changeLabel.text = "-"
        changeLabel.textColor = UIColor.theme.secondaryLabel
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 11.0, weight: .regular)
        
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
        self.item = item
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: Notification.Name("T.\(item.symbol)"), object: nil)
        //item.setDelegate(key: "home", self)
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        self.chartViewModel.isObserving = true
        self.didUpdate()
    }
    
    @objc func didUpdate() {
        guard let item = self.item else { return }
        if let price = item.price {
            priceLabel.text = price.priceFormatted
        } else {
            priceLabel.text = "-"
        }

        changeLabel.text = item.changeFullStr
        let changeColor = item.changeColor
        changeLabel.textColor = changeColor
        
        chartViewModel.setTrades(item.trades, color: changeColor)
    }
    
    func stopUpdating() {
        NotificationCenter.default.removeObserver(self)
        //self.chartView.cancelTimer()
        self.chartViewModel.isObserving = false
    }
    
    func startUpdating() {
        guard let item = self.item else { return }
        setup(item: item)
        //self.chartView.instantiateTimer()
    }
}
