//
//  StocksRow.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-11.
//

import Foundation
import SwiftUI
/*
struct StocksView : View {
    
    let user:User
    let handler:(()->())?
    
    @State var items = [MarketItem]()
    
    let pub = NotificationCenter.default
                .publisher(for: Notification.Name("user.items.updated"))
    
    init(user:User, handler:(()->())?=nil) {
        self.user = user
        self.handler = handler
        //UITableView.appearance().separatorColor = UIColor.clear//.separator.withAlphaComponent(0.3)
        //UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        UITableView.appearance().scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        
        UITableView.appearance().separatorStyle = .none
    }

    var body: some View {
        ZStack {
            
            Rectangle()
                .background(Color.blue)
        
            List {

                ForEach(0..<items.count, id: \.self) { i in
                    
    //                if i > 0 {
    //                    Divider()
    //                        .opacity(0.3)
    //                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    //                }
                    
                    let item = items[i]
                    Button(action: {
                        print("LetsGo")
                        self.handler?()
                    }) {
                        ItemRow(item: item)
                            
                    }.foregroundColor(Color(UIColor.label))
                    
                    
                        
                }
                .onDelete(perform: { x in
                    print("delete!")
                })
                .listRowBackground(Color(UIColor.Theme.background2))
                

            }.listStyle(PlainListStyle())
            
            
            
            .background(Color(UIColor.Theme.background2))
        }
        
        .onAppear {
            refresh()
            UITableView.appearance().separatorStyle = .none
        }
        .onReceive(pub) { _ in
            refresh()
        }
    }
    
    func refresh() {
        self.items = user.items.map {
            return $0.item
        }
    }
}
*/
