//
//  TradingDiaryRealmModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation
import RealmSwift

class TradingDiaryRealmModel: Object {
    
    @Persisted var corpName: String // 기업명(필수)
    @Persisted var corpCode: String // 종목코드(필수) = srtn code

    @Persisted var tradingPrice : Int // 매매 가격(필수)
    @Persisted var tradingAmount : Int // 매매 수량(필수)
    @Persisted var buyAndSell : Bool // 매수매도 구분(필수) -> false=매수, true=매도
    @Persisted var regDate = Date()  // 등록 날짜(필수)
    @Persisted var tradingDate = Date()  // 매매 일자(필수)
    @Persisted var tradingMemo : String? // 매매일지 메모(옵션)
    
    @Persisted(primaryKey: true) var objectId: ObjectId

    convenience init(corpName: String, corpCode: String, tradingPrice: Int, tradingAmount: Int, regDate: Date, tradingDate: Date, tradingMemo: String?) {
        self.init()
        self.corpName = corpName
        self.corpCode = corpCode
        self.tradingPrice = tradingPrice
        self.tradingAmount = tradingAmount
        self.buyAndSell = false
        self.regDate = regDate
        self.tradingDate = tradingDate
        self.tradingMemo = tradingMemo
    }
    
}
