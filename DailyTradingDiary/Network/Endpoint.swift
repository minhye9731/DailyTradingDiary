//
//  Endpoint.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation

enum Endpoint {
    
    case krxItemInfo
    case apisStockInfo
    
    case alphaNews
    case alpnaFX
    case alphaTreasury
    
    case dartCorpCode
    case dartFinInfo
    case dartDivdInfo
    
    var requestURL: String {
        switch self {
        case .krxItemInfo:
            return URL.apisMakeEndPointString("/GetKrxListedInfoService/getItemInfo?")
        case .apisStockInfo:
            return URL.apisMakeEndPointString("/GetStockSecuritiesInfoService/getStockPriceInfo?")
            
        case .alphaNews:
            return URL.alphaEndPointString("function=NEWS_SENTIMENT")
        case .alpnaFX:
            return URL.alphaEndPointString("function=FX_DAILY")
        case .alphaTreasury:
            return URL.alphaEndPointString("function=TREASURY_YIELD")
        
        case .dartCorpCode:
            return URL.dartEndPointString("/corpCode.xml")
        case .dartFinInfo:
            return URL.dartEndPointString("/fnlttSinglAcntAll.json")
        case .dartDivdInfo:
            return URL.dartEndPointString("/alotMatter.json")
        }
    }
    
    
    
}
