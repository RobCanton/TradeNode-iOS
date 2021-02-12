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
    
    var screenView:UIView!
    var symbolLabel:UILabel!
    var priceLabel:UILabel!
    var changeLabel:UILabel!
    var closeButton:UIButton!
    
    weak var item:Item?
    var updateChart = true
    var updatePrices = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.theme.secondaryBackground.withAlphaComponent(0.85)
        self.constraintHeight(to: Self.height)
        
//        let itemRow = ItemRow(item: MarketItem(from: SymbolSearchResult(s: "", b: "", n: "", x: "", c: 0)))
//        let viewCtrl = UIHostingController(rootView: itemRow)
////
//        self.addSubview(viewCtrl.view)
//        viewCtrl.view.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
//        viewCtrl.view.backgroundColor = UIColor.clear
        
        screenView = UIView()
        screenView.backgroundColor = UIColor.black
        self.addSubview(screenView)
        screenView.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: true)
        screenView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        
        let contentView = UIView()
        
        self.addSubview(contentView)
        contentView.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        contentView.leadingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: 12.0).isActive = true
        
        symbolLabel = UILabel()
        symbolLabel.text = "-"
        symbolLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(8, 0, nil, 8, ignoreSafeArea: true)
        
        //titleStack.addArrangedSubview(symbolLabel)
        
        priceLabel = UILabel()
        priceLabel.text = "-"
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: .medium)
        contentView.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, 0, 10, nil, ignoreSafeArea: true)
        
        changeLabel = UILabel()
        changeLabel.text = "-"
        changeLabel.textColor = UIColor(hex: "00CC8C")
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 12.0, weight: .light)
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, nil, nil, 8, ignoreSafeArea: true)
        changeLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 6.0).isActive = true
        changeLabel.lastBaselineAnchor.constraint(equalTo: priceLabel.lastBaselineAnchor, constant: 0.0).isActive = true
        
        
        closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "Close"), for: .normal)
        self.addSubview(closeButton)
        closeButton.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        closeButton.constraintWidth(to: 52)
        closeButton.backgroundColor = UIColor.clear
        closeButton.tintColor = UIColor.label
        
        closeButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
        
    }
    
    @objc func handleTap() {
        guard let item = self.item else { return }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-item"), object: nil, userInfo: ["item": item])
    }
    
    @objc func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        if translation.y < 0 {
            self.handleTap()
        }
    }
    
    func setup(item:Item) {
        self.item = item
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: Notification.Name("T.\(item.symbol)"), object: nil)
        symbolLabel.text = item.symbol
        didUpdate()
        self.isHidden = false
    }
    
    @objc func didUpdate() {
        guard let item = self.item else { return }
        if updatePrices {
            if let price = item.trades.last?.price {
                priceLabel.text = price.priceFormatted
            } else {
                priceLabel.text = "-"
            }
            
            changeLabel.text = item.changeStr
            changeLabel.textColor = item.changeColor
        }
        
        if updateChart {
            //chartViewModel.setTrades(item.trades, color: changeColor)
        }
    }
    
    @objc func dismiss() {
        self.item = nil
        NotificationCenter.default.removeObserver(self)
        self.isHidden = true
    }
}
