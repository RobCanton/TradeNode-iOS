//
//  API+Ref.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//

import Foundation
import Combine
extension API {
    struct Ref {
        static func searchSymbols(query:String) -> AnyPublisher<[SymbolSearchResult], Error> {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return NetworkManager.shared.request(.GET, .searchSymbols(query: encodedQuery), ofType: [SymbolSearchResult].self)
        }
    }
}
