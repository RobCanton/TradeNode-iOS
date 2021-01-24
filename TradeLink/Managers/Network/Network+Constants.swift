//
//  Environment.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-10.
//

import Foundation

class Constants {
    
}

extension Constants {
    struct Network {
        static let hostURL = "https://replicode.app"
        
        enum Endpoints {
            case searchSymbols(query:String)
            
            var str:String {
                switch self {
                case .searchSymbols(let query):
                    return "/ref/search?query=\(query)"
                }
            }
        }
    }
}
