//
//  MarketManager.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-16.
//

import Foundation

/*
class MarketManager:NSObject {

    //var firestore = Firestore.firestore()
    
    static let shared = MarketManager()
    
    private(set) var itemsDict = [String:MarketItem]()
    private(set) var watchlist = [String]()
    
    private(set) var watchlistItems = [MarketItem]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("MarketItemsUpdated"), object: nil)
        }
    }

        
    private override init() {
        
    }
    
    
    
    
    func addItem(_ item:MarketItem) {
//        /*
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//
//        let rank = watchlist.count
//        let ref = firestore.collection("users").document(uid).collection("watchlist")
//
//        ref.document(item.symbol).setData([
//            "cluster": item.cluster.name,
//            "rank": rank,
//            "tags": ["tech"]
//        ], merge: true, completion: { error in
//            guard error == nil else { return }
//            self.itemsDict[item.symbol] = item
//            self.watchlist.append(item.symbol)
//
//            self.watchlistItems = self.watchlist.compactMap {
//                return self.itemsDict[$0]
//            }
//        })
//        */
//
//        itemsDict[item.symbol] = item
//        watchlist.append(item.symbol)
//
//        watchlistItems = watchlist.compactMap {
//            return itemsDict[$0]
//        }
//
//        subscribe(to: item)
        
        
    }
    
    func subscribe(to item:MarketItem) {
        RNSocketManager.shared.emit(.subscribeToItem(item))
        
        if let _ = item as? StockItem {
            RNSocketManager.shared.on(.stockTrade(item)) { data, ack in

                guard let first = data.first as? [String:Any] else { return }
                guard let p = first["p"] as? Double else { return }

                if let stockItem = self.itemsDict[item.symbol] as? StockItem {
                    let trade = Stock.Trade(p: p)
                    stockItem.trades.append(trade)
                    NotificationCenter.default.post(name: Notification.Name("T.\(item.socketSymbol)"), object: nil)
                }
                
            }
        } else if let _ = item as? CryptoItem {
            RNSocketManager.shared.on(.cryptoTrade(item)) { data, ack in

                guard let first = data.first as? [String:Any] else { return }
                guard let p = first["p"] as? Double else { return }

                if let cryptoItem = self.itemsDict[item.symbol] as? CryptoItem {
                    let trade = Crypto.Trade(p: p)
                    cryptoItem.trades.append(trade)
                    NotificationCenter.default.post(name: Notification.Name("XT.\(item.socketSymbol)"), object: nil)
                }
                
            }
        }
    }
    

    

}
*/
