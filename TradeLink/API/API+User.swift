//
//  API+User.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-18.
//

import Foundation
import Combine
extension API {
    struct User {
        
        static func get() -> AnyPublisher<UserDTO, Error> {
            return NetworkManager.shared.request(.GET, .user, ofType: UserDTO.self)
        }
        
        static func create(_ dto:UserCreateDTO) -> AnyPublisher<UserDTO, Error> {
            let body = try? JSONEncoder().encode(dto)
            return NetworkManager.shared.request(.POST, .user, body: body, ofType: UserDTO.self)
            
        }
        
        static func watchlistAdd(symbol:String) -> AnyPublisher<UserItemDTO, Error> {
            return NetworkManager.shared.request(.POST, .userWatchlistBySymbol(symbol), ofType: UserItemDTO.self)
        }
        
        static func watchlistUpdate(dto:[UserItemCreateDTO]) -> AnyPublisher<[UserItemDTO], Error> {
            struct Request:Codable {
                let items:[UserItemCreateDTO]
            }
            let request = Request(items: dto)
            let body = try! JSONEncoder().encode(request)
            
            return NetworkManager.shared.request(.PUT, .userWatchlist, body: body, ofType: [UserItemDTO].self)
        }
        
//        static func searchSymbols(query:String) -> AnyPublisher<[SymbolSearchResult], Error> {
//            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//            return NetworkManager.shared.request(.GET, .searchSymbols(query: encodedQuery), ofType: [SymbolSearchResult].self)
//        }
    }
}
