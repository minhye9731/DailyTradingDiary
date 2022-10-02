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
        case corpRigMemoPlchdr = "매수·매도 혹은 보류하려는 이유를 적어주세요 (공백 포함 최대 300자)"
        case trdDryMemoPlchdr = "매수·매도의 근거와 전략을 적어주세요 (공백 포함 최대 300자)"
        
    }
    
    enum CurrencySign: String {
        
        case won = "￦"
        case dollar = "$"
        case euro = "€"
        case yuanAndyen = "¥"
    }
    
}
