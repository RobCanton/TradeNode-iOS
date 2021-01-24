//
//  UserItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation

struct UserItemDTO:Codable {
    let id:Int
    let item: ItemDTO
}

struct UserItemCreateDTO:Codable {
    let symbol:String
    let tags:[String]
}

//struct WatchlistUpdateRequestDTO:Codable {
//    let items
//}
