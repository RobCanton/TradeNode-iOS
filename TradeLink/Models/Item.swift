//
//  Item.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation
import UIKit

protocol ItemDelegate {
    func didUpdate(_ item:Item)
}

protocol Item:class {
    var symbol: String { get }
    var base: String { get }
    var socketSymbol: String { get }
    var name: String { get }
    var cluster: MarketCluster { get }
    
    var trades:[Trade] { get }
    var price:Double? { get }
    var prevClose:Double? { get }
    var change:Double? { get }
    var changePercent:Double? { get }
    var changeStr:String { get }
    var changePercentStr:String { get }
    var changeFullStr:String { get }
    var changeColor:UIColor { get }
    
    var delegates:[String:ItemDelegate] { get }
    
    
    func observe()
    func stopObserving()
    
    func getJSONRepresentation() -> [String:Any]
    func setDelegate(key:String, _ delegate:ItemDelegate)
    func removeDelegate(key:String)
    func updateDelegates()
    
    
    
}

extension Item {
    func getJSONRepresentation() -> [String:Any] {
        return [
            "symbol": symbol,
            "base": base,
            "socketSymbol": socketSymbol,
            "name": name,
            "cluster": cluster.name
        ]
    }
    
}

protocol Trade {
    var price:Double { get }
    var timestamp:Double { get }
}

func parseItem(from dto:ItemDTO) -> Item? {
    let cluster = MarketCluster(rawValue: dto.cluster) ?? .none

    var item:Item?
    switch cluster {
    case .stocks:
        item = StockItem(from: dto)
        break
    case .crypto:
        item = CryptoItem(from: dto)
        break
    default:
        break
    
    }
    return item
    
}

enum StatType:String {
    case open = "Open"
    case low = "Low"
    case high = "High"
    case volume = "Volume"
    case marketCap = "Mkt Cap"
    case prevClose = "Prev Close"
    case close = "Close"
    
    static let all = [open, low, high, volume, marketCap, prevClose, close]
    static let forex = [open, low, high, volume, prevClose]
    static let crypto = [open, low, high, volume]
}


struct StatValue {
    let type:StatType
    let value:String
}
