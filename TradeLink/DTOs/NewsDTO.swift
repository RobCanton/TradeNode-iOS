//
//  NewsDTO.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-02-12.
//

import Foundation

struct NewsDTO:Codable {
    
    static var dateFormatter:DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    let news_url:String
    let image_url:String
    let title: String
    let text: String
    let source_name: String
    let date: String
    let topics: [String]
    let sentiment: String
    let type: String
    let tickers:[String]
    
    var newsURL:URL? {
        return URL(string: news_url)
    }
    
    var imageURL:URL? {
        return URL(string: image_url)
    }
    
    var dateObject:Date? {
        return Self.dateFormatter.date(from: date)
    }
    
    var dateFormatted:String {
        guard let date = dateObject else { return "" }
        var dateFormat = ""
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormat = "h:mm a"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormat = "MMMM d"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    
}
