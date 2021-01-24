//
//  ItemRow.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-11.
//

import Foundation
import SwiftUI

struct ItemRow: View {
    let item:MarketItem
    let pub:NotificationCenter.Publisher
    
    @State var price:Double?
    
    init(item:MarketItem) {
        self.item = item
        
        if let _ = item as? StockItem {
            self.pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("T.\(item.socketSymbol)"))
        } else {
            self.pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("XT.\(item.socketSymbol)"))
        }
        
        
        self.price = item.price
        
    }
    
    var priceStr:String {
        if let price = self.price {
            return price.priceFormatted
        }
        return "-"
    }
    
   
    
    var body: some View {
        VStack(spacing: 8.0) {
            HStack {
                
                HStack {
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(item.symbol)
                            .font(.system(size: 18.0, weight: .semibold))
//                            .font(.custom("ProximaNova-Semibold", size: 17))
                        Text(item.name)
                            .font(.system(size: 13.0, weight: .regular))
//                            .font(.custom("ProximaNova-Regular", size: 12))
                            .lineLimit(1)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        

                    }
                    Spacer()
                }
                .frame(width: 100)

                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2.0) {
                    Text(priceStr)
                        .font(.system(size: 18.0, weight: .semibold, design: .monospaced))
//                        .font(.custom("ProximaNova-Regular", size: 17))
                    Text("+6.78")
                        .font(.system(size: 14.0, weight: .light, design: .monospaced))
//                        .font(.custom("ProximaNova-Regular", size: 15))
                        .foregroundColor(Color(UIColor(hex: "02D277")))
                }
                
            }
            Divider()
                .opacity(0.25)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        //.padding(.horizontal, 16)
        
        .padding(.vertical, 8.0)

        .onReceive(pub) { _ in
            self.price = item.price
        }
    }
}

