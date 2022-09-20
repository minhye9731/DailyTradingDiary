//
//  URL+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation

extension URL {
    
    static let krxBaseURL = "https://apis.data.go.kr/1160100/service/GetKrxListedInfoService/"
    
    static let alphaURL = "https://www.alphavantage.co/query?"
    
    
    
    
    static func krxMakeEndPOintString(_ endpoint: String) -> String {
        return krxBaseURL + endpoint
    }
    
    static func alphaEndPointString(_ endpoint: String) -> String {
        return alphaURL + endpoint
    }
    
    
}
