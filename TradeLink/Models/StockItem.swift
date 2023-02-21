//
//  StockItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-19.
//

import Foundation
import UIKit


class StockItem:Item {
    
    
    
    let symbol: String
    let base: String
    let socketSymbol: String
    let name: String
    let cluster: MarketCluster
    
    var delegates: [String:ItemDelegate]
    
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
        var color = UIColor.theme.neutralLabel
        if let change = change {
            if change > 0 {
                color = UIColor.theme.positiveLabel
            } else if change < 0 {
                color = UIColor.theme.negativeLabel
            }
        }
        return color
    }
    
    init(from dto: ItemDTO) {
        self.symbol = dto.symbol
        self.base = dto.base
        self.socketSymbol = dto.symbol
        self.name = dto.name
        self.cluster = .stocks
        
        self.trades = []
        self.delegates = [:]
        
        if let data = dto.data {
            if let lastPriceStr = data.price,
               let lastPrice = Double(lastPriceStr),
               let lastUpdatedStr = data.lastUpdated,
               let lastUpdated = Double(lastUpdatedStr) {
                 
                 print("lastPrice: \(lastPrice)")
                 print("lastUpdated: \(lastUpdated)")
                 let trade = StockTrade(price: lastPrice, timestamp: lastUpdated)
                 self.trades.append(trade)
            }
              
            if let prevCloseStr = data.prevClose,
                let prevClose = Double(prevCloseStr) {
                self.prevClose = prevClose
            }
            
        }
        
        
    }
    
    struct StockTrade:Trade {
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

            let trade = StockTrade(price: p, timestamp: t)
            self.trades.sort(by: {
                return $0.timestamp < $1.timestamp
            })
            self.trades.append(trade)
            
            if self.trades.count > 750 {
                let _ = self.trades.removeFirst()
            }
            
            //self.updateDelegates()
            NotificationCenter.default.post(Notification(name: Notification.Name("T.\(self.symbol)")))
        }
    }
    
    func stopObserving() {
        //RNSocketManager.shared.emit(.subscribeToItem(self))
        RNSocketManager.shared.off(.itemTrade(self))
    }
}

struct Stock:Codable {
    struct Trade:Codable {
        let p: Double
    }
}
