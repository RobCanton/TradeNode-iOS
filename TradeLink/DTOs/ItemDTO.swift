//
//  Item.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation


struct ItemDTO:Codable {
    let symbol: String
    let base: String
    let name :String
    let cluster: Int
    let exchange: String?
    let data:ItemDataDTO?
    //let marketCap: String?
    //let shares: String?
    //let averagePrice: Double?
}

struct ItemDataDTO:Codable {
    let price: String?
    let change: String?
    let prevClose: String?
    let open: String?
    let high: String?
    let low: String?
}
