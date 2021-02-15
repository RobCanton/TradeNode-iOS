//
//  UserItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation

class UserItem {
    let id:String
    let symbol:String
    let tags:[String]
    
    init?(dto: UserItemDTO) {
        guard let item = dto.item else { return nil }
        self.id = dto.id
        self.symbol = item.symbol
        self.tags = ["tech"]
    }
}
