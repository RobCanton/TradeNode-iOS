//
//  CryptoItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-16.
//

import Foundation

class CryptoItem:Item {
    
    let symbol: String
    let base: String
    let socketSymbol: String
    let name: String
    let cluster: MarketCluster
    
    var delegates: [String:ItemDelegate]
    
    init(from dto: ItemDTO) {
        self.symbol = dto.symbol
        self.base = dto.base
        self.socketSymbol = "\(dto.base)-USD"
        self.name = dto.name
        self.cluster = .crypto
    
        self.trades = []
        self.delegates = [:]
    }
    
    var trades: [Trade]
    
    var price: Double? {
        return trades.last?.price
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

struct Crypto:Codable {
    struct Trade:Codable {
        let p: Double
    }
}
