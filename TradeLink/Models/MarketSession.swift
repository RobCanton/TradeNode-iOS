//
//  MarketSession.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation
import Combine

protocol MarketSessionDelegate {
    func userItemsUpdated(shouldReload:Bool)
}

class MarketSession {
    
    var requests = Set<AnyCancellable>()
    
    var userItems:[UserItem]
    var itemsDict:[String:Item]
    
    var userWatchlist:[Item] {
        var array = [Item]()
        for item in userItems {
            if let item = itemsDict[item.symbol] {
                array.append(item)
            }
        }
        return array
    }
    
    var delegate:MarketSessionDelegate?
    
    init(userItems:[UserItemDTO]) {
        //self.user = user
        self.userItems = [UserItem]()
        
        itemsDict = [:]
        
        for userItemDTO in userItems {
            if let item = parseItem(from: userItemDTO.item) {
                self.addItem(item)
                let userItem = UserItem(dto: userItemDTO)
                self.userItems.append(userItem)
            }
        }
        
        RNSocketManager.shared.delegate = self
        RNSocketManager.shared.connect()
        
    }
    
    func observeAll() {
        for (_, item) in itemsDict {
            item.observe()
        }
    }
    
    func addItem(_ item:Item) {
        if let existingItem = itemsDict[item.symbol] {
            
        } else {
            self.itemsDict[item.symbol] = item
        }
        
    }
    
    func requestAddItem(with symbol:String) {
        if userItems.contains(where: {
            return $0.symbol == symbol
        }) {
            print("Item already added!")
            return
        }
        
        API.User.watchlistAdd(symbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { state in
                
            }, receiveValue: { response in
                
                if let item = parseItem(from: response.item) {
                    self.addItem(item)
                    item.observe()
                    let userItem = UserItem(dto: response)
                    self.userItems.append(userItem)
                    self.delegate?.userItemsUpdated(shouldReload: true)
                }
                
                
            })
            .store(in: &requests)
    }
    
    func requestMoveItem(from sourceIndex:Int, to destinationIndex:Int) {
        let moveItem = self.userItems.remove(at: sourceIndex)
        self.userItems.insert(moveItem, at: destinationIndex)
        self.delegate?.userItemsUpdated(shouldReload: false)
        
        requestWatchlistUdpate()
    }
    
    func requestRemoveItem(at index:Int) {
        
        let userItem = self.userItems.remove(at: index)
        self.delegate?.userItemsUpdated(shouldReload: false)
        
        if let item = itemsDict[userItem.symbol] {
            item.stopObserving()
            itemsDict[item.symbol] = nil
        }
        
        requestWatchlistUdpate()
        
    }
    
    private func requestWatchlistUdpate() {
        var dto = [UserItemCreateDTO]()
        for item in userItems {
            dto.append(UserItemCreateDTO(symbol: item.symbol,
                                         tags: item.tags))
        }

        API.User.watchlistUpdate(dto: dto)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { state in
                
            }, receiveValue: { response in
                
                
            })
            .store(in: &requests)
    }
    
    
    
    
}

extension MarketSession:RNSocketDelegate {
    func socketConnected() {
        for (_, item) in itemsDict {
            item.observe()
        }
    }
    
    func socketDisconnected() {
        for (_, item) in itemsDict {
            item.stopObserving()
        }
    }
}
