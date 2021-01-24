//
//  StockItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-19.
//

import Foundation

class StockItem:Item {
    
    let symbol: String
    let base: String
    let socketSymbol: String
    let name: String
    let cluster: MarketCluster
    
    var delegates: [String:ItemDelegate]
    
    init(from dto: ItemDTO) {
        self.symbol = dto.symbol
        self.base = dto.base
        self.socketSymbol = dto.symbol
        self.name = dto.name
        self.cluster = .stocks
        
        self.trades = []
        self.delegates = [:]
        
        
    }
    
    struct StockTrade:Trade {
        let price:Double
        let timestamp:Double
    }
    
    var trades: [Trade]
    
    var price: Double? {
        return trades.last?.price
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
            
            self.trades.append(trade)

            if self.trades.count > 500 {
                let _ = self.trades.removeFirst()
            }
            self.trades.sort(by: {
                return $0.timestamp < $1.timestamp
            })
            
            self.updateDelegates()

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
