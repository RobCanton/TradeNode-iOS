//
//  Stock.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-05.
//

import Foundation


enum MarketCluster:Int {
    case none = 0
    case stocks = 1
    case forex = 2
    case crypto = 3
    
    var name:String {
        switch self {
        case .none:
            return "none"
        case .stocks:
            return "stocks"
        case .forex:
            return "forex"
        case .crypto:
            return "crypto"
        }
    }
    
    var tradeSymbol:String {
        switch self {
        case .none:
            return ""
        case .stocks:
            return "T"
        case .forex:
            return "T"
        case .crypto:
            return "XT"
        }
    }
}


class MarketItem {
    let symbol: String
    let base: String
    let name:String
    let cluster:MarketCluster
    let socketSymbol:String
    private(set) var isObserving = false
    
    
    
    init (from result:SymbolSearchResult) {
        self.symbol = result.s
        self.base = result.b
        self.name = result.n
        self.cluster = MarketCluster(rawValue: result.c) ?? .none
        
        switch cluster {
        case .crypto:
            self.socketSymbol = "\(result.b)-USD"
        default:
            self.socketSymbol = result.s
        }
    }
    
    init (from dto:ItemDTO) {
        self.symbol = dto.symbol
        self.base = dto.base
        self.name = dto.name
        self.cluster = MarketCluster(rawValue: dto.cluster) ?? .none
        
        switch cluster {
        case .crypto:
            self.socketSymbol = "\(dto.base)-USD"
        default:
            self.socketSymbol = dto.symbol
        }
    }
    
    var data:[String:Any] {
        return [
            "symbol": symbol,
            "base": base,
            "socketSymbol": socketSymbol,
            "name": name,
            "cluster": cluster.name
        ]
    }
    
    static func parse(from result:SymbolSearchResult) -> MarketItem? {
        return nil
//        let cluster = MarketCluster(rawValue: result.c) ?? .none
//        switch cluster {
//        case .stocks:
//            let item = StockItem(from: result)
//            return item
//        case .crypto:
//            let item = CryptoItem(from: result)
//            return item
//        default:
//            return nil
//        }
    }
    
    var price:Double? {
        return nil
    }
    
    func observe() {

    }
    
}

// Methods
extension MarketItem {
    
    
    
}
