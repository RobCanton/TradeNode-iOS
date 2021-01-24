//
//  UserItem.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation

class UserItem {
    let id:Int
    let symbol:String
    let tags:[String]
    
    init(dto: UserItemDTO) {
        self.id = dto.id
        self.symbol = dto.item.symbol
        self.tags = ["tech"]
    }
}
