//
//  UserSession.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation


class UserSession {
    let user:User
    
    init(userData:UserDTO) {
        self.user = User(dto: userData)
    }
}
