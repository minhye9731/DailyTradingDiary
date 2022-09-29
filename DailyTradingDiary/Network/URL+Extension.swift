//
//  URL+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation

extension URL {
    
    static let apisBaseURL = "https://apis.data.go.kr/1160100/service"
    
    static let alphaURL = "https://www.alphavantage.co/query?"
    
    static let fearGreedURL = "https://fear-and-greed-index.p.rapidapi.com/v1/fgi"
    
    static let dartBaseURL = "https://opendart.fss.or.kr/api"
    
    
    static func apisMakeEndPointString(_ endpoint: String) -> String {
        return apisBaseURL + endpoint
    }
    
    static func alphaEndPointString(_ endpoint: String) -> String {
        return alphaURL + endpoint
    }
    
    static func dartEndPointString(_ endpoint: String) -> String {
        return dartBaseURL + endpoint
    }
    
    
}
