//
//  User.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation

class User {
    var username:String
    var items:[UserItem]
    init(dto:UserDTO) {
        self.username = dto.username
        self.items = []
        for itemDTO in dto.items ?? [] {
            if let item = UserItem(dto: itemDTO) {
                self.items.append(item)
            }
        }
    }
}
