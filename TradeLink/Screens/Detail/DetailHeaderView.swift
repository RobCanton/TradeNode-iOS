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
    var contentView:UIView!
    var symbolLabel:UILabel!
    var nameLabel:UILabel!
    var priceLabel:UILabel!
    var changeLabel:UILabel!
    
    var chartViewModel:ChartViewModel!
    var chartView:ChartView!
    
    weak var item:Item?
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
        contentView = UIView()
        self.addSubview(contentView)
        contentView.constraintToSuperview(insets: .zero, ignoreSafeArea: true)
        
        let titleRow = UIView()
        contentView.addSubview(titleRow)
        titleRow.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: true)
        titleRow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        nameLabel.text = "Apple Inc"
        nameLabel.textColor = .secondaryLabel
        titleRow.addSubview(nameLabel)
        nameLabel.constraintToSuperview(nil, 12, 12, 8, ignoreSafeArea: true)
        
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        symbolLabel.text = "AAPL"
        titleRow.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(nil, 12, nil, 8, ignoreSafeArea: true)
        symbolLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -4.0).isActive = true
        
        let priceRow = UIView()
        contentView.addSubview(priceRow)
        priceRow.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        priceRow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        changeLabel = UILabel()
        changeLabel.text = "-"
        changeLabel.textAlignment = .right
        changeLabel.textColor = UIColor(hex: "00CC8C")
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 12.0, weight: .light)
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, 8, 12, 12, ignoreSafeArea: true)
        
        
        priceLabel = UILabel()
        priceLabel.text = "-"
        priceLabel.textAlignment = .right
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: .medium)
        priceRow.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, 8, nil, 12, ignoreSafeArea: true)
        priceLabel.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: -4.0).isActive = true
        
        chartViewModel = ChartViewModel()
        chartView = ChartView(viewModel: chartViewModel)
        let host = UIHostingController(rootView: chartView)
        contentView.addSubview(host.view)
        host.view.constraintToSuperview(12, 12, 52, 12, ignoreSafeArea: false)
        //host.view.bottomAnchor.constraint(equalTo: titleRow.topAnchor, constant: 8.0).isActive = true
        host.view.backgroundColor = UIColor.clear
        host.view.clipsToBounds = true
        
//        let itemRow = ItemRow(symbol: "AAPL", name: "Apple Inc")
//        let viewCtrl = UIHostingController(rootView: itemRow)
////
//        self.addSubview(viewCtrl.view)
//        viewCtrl.view.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
//        viewCtrl.view.constraintHeight(to: MinibarView.height)
//        viewCtrl.view.backgroundColor = UIColor.clear
//        viewCtrl.view.backgroundColor = UIColor.clear
    }
    
    func setup(item:Item) {
        self.item = item
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: Notification.Name("T.\(item.symbol)"), object: nil)
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        didUpdate()
        self.isHidden = false
    }
    
    @objc func didUpdate() {
        guard let item = self.item else { return }
        if let price = item.trades.last?.price {
            priceLabel.text = price.priceFormatted
        } else {
            priceLabel.text = "-"
        }
        
        let changeColor = item.changeColor
        changeLabel.text = item.changeFullStr
        changeLabel.textColor = changeColor
        
        chartViewModel.setTrades(item.trades, color: changeColor)
//        if updateChart {
//            //chartViewModel.setTrades(item.trades, color: changeColor)
//        }
    }
}
