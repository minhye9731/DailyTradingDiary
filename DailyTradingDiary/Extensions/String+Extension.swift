//
//  String+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toDateinUTC() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }

    func toDateinKR() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }


}
