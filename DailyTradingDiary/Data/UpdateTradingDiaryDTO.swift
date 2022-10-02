//
//  UpdateTradingDiaryDTO.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/2/22.
//

import Foundation

struct UpdateTradingDiaryDTO {
    var corpName: String // 기업명(필수)
    var corpCode: String // 종목코드(필수)

    var tradingPrice : Int // 매매 가격(필수)
    var tradingAmount : Int // 매매 수량(필수)
    
    var buyAndSell : Bool // 매수매도 구분(필수) -> false가 '매수', true가 '매도'
    
    var regDate : Date  // 등록 날짜(필수)
    var tradingDate : Date // 매매 일자(필수)
    var tradingMemo : String? // 매매일지 메모(옵션)
}
