//
//  User.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation



struct UserDTO:Codable {
    let id: String
    let username: String
    let items:[UserItemDTO]?
}

struct UserCreateDTO:Codable {
    let username:String
}
