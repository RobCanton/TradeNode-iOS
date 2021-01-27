//
//  CryptoItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-16.
//

import Foundation
import UIKit

class CryptoItem:Item {
    
    let symbol: String
    let base: String
    let socketSymbol: String
    let name: String
    let cluster: MarketCluster
    
    var trades: [Trade]
    
    var price: Double? {
        return trades.last?.price
    }
    
    var prevClose:Double?
    
    var change:Double? {
        guard let price = price, let prevClose = prevClose else { return nil }
        return price - prevClose
    }
    
    var changePercent:Double? {
        guard let change = change, let prevClose = prevClose else { return nil }
        return change / prevClose
    }
    
    var changeStr:String {
        guard let change = change else { return "" }
        return String(format: "%.2f", change)
    }
    
    var changePercentStr:String {
        guard let changePercent = changePercent else { return "-" }
        return "\(String(format: "%.2f", changePercent * 100))%"
    }
    
    var changeFullStr:String {
        return "\(changeStr) (\(changePercentStr))"
    }
    
    var changeColor:UIColor {
        var color = UIColor.gray
        if let change = change {
            if change > 0 {
                color = UIColor(hex: "00CC8C")
            } else if change < 0 {
                color = UIColor(hex: "FE3653")
            }
        }
        return color
    }
    
    var delegates: [String:ItemDelegate]
    
    init(from dto: ItemDTO) {
        self.symbol = dto.symbol
        self.base = dto.base
        self.socketSymbol = "\(dto.base)-USD"
        self.name = dto.name
        self.cluster = .crypto
    
        self.trades = []
        self.delegates = [:]
        
        if let data = dto.data {
            if let lastPriceStr = data.price,
               let lastPrice = Double(lastPriceStr),
               let lastUpdatedStr = data.lastUpdated,
               let lastUpdated = Double(lastUpdatedStr) {
                 
                 print("lastPrice: \(lastPrice)")
                 print("lastUpdated: \(lastUpdated)")
                 let trade = CryptoTrade(price: lastPrice, timestamp: lastUpdated)
                 self.trades.append(trade)
            }
              
            if let prevCloseStr = data.prevClose,
                let prevClose = Double(prevCloseStr) {
                self.prevClose = prevClose
            }
            
        }
    }
    
    struct CryptoTrade:Trade {
        let price:Double
        let timestamp:Double
    }

    func setDelegate(key: String, _ delegate: ItemDelegate) {
        self.delegates[key] = delegate
    }
    
    func removeDelegate(key: String) {
        self.delegates[key] = nil
    }
    
    func updateDelegates() {
        for (_, delegate) in delegates {
            delegate.didUpdate(self)
        }
    }
    
    func observe() {
        RNSocketManager.shared.emit(.subscribeToItem(self))
        RNSocketManager.shared.on(.itemTrade(self)) { data, ack in

            guard let first = data.first as? [String:Any] else { return }
            guard let p = first["p"] as? Double else { return }
            guard let t = first["t"] as? Double else { return }

            let trade = CryptoTrade(price: p, timestamp: t)

            self.trades.append(trade)

            if self.trades.count > 750 {
                let _ = self.trades.removeFirst()
            }
            
            self.trades.sort(by: {
                return $0.timestamp < $1.timestamp
            })
            
            //self.updateDelegates()
            NotificationCenter.default.post(Notification(name: Notification.Name("T.\(self.symbol)")))

        }
    }
    
    func stopObserving() {
        //RNSocketManager.shared.emit(.subscribeToItem(self))
        RNSocketManager.shared.off(.itemTrade(self))
    }
}

struct Crypto:Codable {
    struct Trade:Codable {
        let p: Double
    }
}
