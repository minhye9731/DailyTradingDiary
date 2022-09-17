//
//  Word.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation

extension Constants {
    
    enum Word: String {
        
        case countStock = "주"
        case tradingPrice = "매매단가"
        case buy = "매수"
        case sell = "매도"
    }
    
    enum CurrencySign: String {
        
        case won = "￦"
        case dollar = "$"
        case euro = "€"
        case yuanAndyen = "¥"
    }
    
}
