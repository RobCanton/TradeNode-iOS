//
//  RNSocket+Events.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-16.
//

import Foundation
import SocketIO

extension RNSocketManager {
    enum Emittable {
        case msgToServer(_ msg:String)
        case subscribeToItem(_ item:Item)
        
        var data:(String, SocketData) {
            switch self {
                case .msgToServer(let msg):
                    return ("msgToServer", msg)
                case .subscribeToItem(let item):
                    return("subscribeTo", item.getJSONRepresentation())
                }
            }
        }

    enum Event {
        case msgToClient
        case itemTrade(_ item:Item)
        
        var name:String {
            switch self {
            case .msgToClient:
                return "msgToClient"
            case .itemTrade(let item):
                let tradeSymbol = item.cluster.tradeSymbol
                return "\(tradeSymbol).\(item.socketSymbol)"
            }
        }
    }

}
