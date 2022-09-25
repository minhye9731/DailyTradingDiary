//
//  Date+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    func toStringinUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    func toStringinKR() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
//    func toDateinKR() -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
//        return dateFormatter.date(from: self)
//        if let date = dateFormatter.date(from: self) {
//            return date
//        } else {
//            return nil
//        }
//    }
}
