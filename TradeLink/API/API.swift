//
//  API.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation


struct API {
    static let hostURL = "https://replicode.app"
    
    enum Endpoints {
        case searchSymbols(query:String)
        case cryptoNews(ticker:String)
        
        case user
        case userWatchlist
        case userWatchlistBySymbol(_ symbol:String)
        
        var str:String {
            switch self {
            case .searchSymbols(let query):
                return "/ref/search?query=\(query)"
            case .cryptoNews(let ticker):
                return "/ref/news/crypto/\(ticker)"
                
            case .user:
                return "/user"
            case .userWatchlist:
                return "/user/watchlist"
            case .userWatchlistBySymbol(let symbol):
                return "/user/watchlist/\(symbol)"
            }
        }
    }
    
}
