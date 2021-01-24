//
//  ChartView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-21.
//

import Foundation
import SwiftUI

class ChartViewModel:ObservableObject {
    @Published var min:Double = 0
    @Published var max:Double = 100
    @Published var timeStart:Double = 0
    @Published var timeEnd:Double = 100
    
    @Published var points = [CGPoint]()
    
    private var trades = [Trade]()
    
    func setTrades(_ trades:[Trade]) {
        self.trades = trades
        //self.calculatePoints()
    }
    
    func calculatePoints() {
        guard trades.count > 2 else { return }
        let latestTrade = trades.last!
        let latestPrice = latestTrade.price
        let diff = latestTrade.price * 0.01
        self.min = latestPrice - diff
        self.max = latestPrice + diff

        self.timeStart = Date().timeIntervalSince1970 * 1000
        self.timeEnd = timeStart - (1000 * 15)

        let xRange = timeStart - timeEnd
        let yRange = max - min
        points = []
        for i in 0..<trades.count {
            let trade = trades[i]
            if (trade.timestamp > timeEnd - (1000 * 5)) {
                let xDiff = trade.timestamp - timeEnd
                let x = xDiff / xRange
                let yDiff = trade.price - min
                let y = yDiff / yRange
                points.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
            
        }
        
    }
}

struct ChartView:View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @ObservedObject var viewModel:ChartViewModel
    @State var count = 0
    
    let lineWidth = 1.5 / UIScreen.main.scale
    
    var body: some View {

        GeometryReader { reader in
            ZStack {
                Path { path in
                    if let lastPoint = viewModel.points.last {
                        let lastX = lastPoint.x * reader.size.width
                        let lastY = lastPoint.y * reader.size.height
                        path.move(to: CGPoint(x: lastX, y: lastY))
                        path.addLine(to: CGPoint(x: reader.size.width, y: lastY))
                    } else {
                        path.move(to: CGPoint(x: 0, y: reader.size.height / 2))
                        path.addLine(to: CGPoint(x: reader.size.width, y: reader.size.height / 2))
                    }
                    
                }
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .stroke(Color(UIColor(hex: "02D277").withAlphaComponent(0.25)), lineWidth: lineWidth)
                
                Path { path in
                    if viewModel.points.count >= 2 {
                        let firstPoint = viewModel.points.first!
                        
                        let firstX = firstPoint.x * reader.size.width
                        let firstY = firstPoint.y * reader.size.height
                        path.move(to: CGPoint(x: firstX, y: firstY))
                        
                        for i in 1..<viewModel.points.count-1 {
                            let point = viewModel.points[i]
                            let x = point.x * reader.size.width
                            let y = point.y * reader.size.height
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        let lastPoint = viewModel.points.last!
                        let lastX = lastPoint.x * reader.size.width
                        let lastY = lastPoint.y * reader.size.height
                        path.addLine(to: CGPoint(x: lastX, y: lastY))
                        
                    } else {
                        
                    }
                    
                }
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .stroke(Color(UIColor(hex: "02D277")), lineWidth: lineWidth)
            }
            
        }
        .clipped()
            
        
        .onReceive(timer) { input in
            viewModel.calculatePoints()
        }
        
    }
    
}
