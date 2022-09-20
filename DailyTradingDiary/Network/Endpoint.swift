//
//  Endpoint.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation

enum Endpoint {
    
    case krxItemInfo
    case alphaNews
    
    var requestURL: String {
        switch self {
        case .krxItemInfo:
            return URL.krxMakeEndPOintString("getItemInfo?")
        case .alphaNews:
            return URL.alphaEndPointString("function=NEWS_SENTIMENT")
        }
    }
    
    
    
}
