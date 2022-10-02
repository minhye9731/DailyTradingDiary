//
//  CorpRegisterRealmModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/30/22.
//

import Foundation
import RealmSwift

class CorpRegisterRealmModel: Object {
    
    @Persisted var formalCorpName: String // 공식 기업명(주) (필수)
    //summary
    @Persisted var updateDate = Date() // 종합정보 업데이트 일자(필수)
    @Persisted var corpName: String // 기업명(필수)
    @Persisted var marketName: String // 상장 시장명(필수)
    @Persisted var srtnCode: String // 종목번호(필수)
    @Persisted var nowPrice: Int // 시가(필수)
    @Persisted var highPrice: Int // 고가(필수)
    @Persisted var lowPrice: Int // 저가(필수)
    @Persisted var tradingQnt: Int // 거래량(필수)
    @Persisted var totAmt: Int // 시가총액(필수)
    // main info (신생기업의 경우 3년치 데이터가 없을 수도 있음)
    @Persisted var revenueThr: Int? // 매출액 (3년 전)
    @Persisted var revenueTwo: Int? // 매출액 (2년 전)
    @Persisted var revenueOne: Int? // 매출액 (1년 전)
    @Persisted var opIncomeThr: Int? // 영업이익 (3년 전)
    @Persisted var opIncomeTwo: Int? // 영업이익 (2년 전)
    @Persisted var opIncomeOne: Int? // 영업이익 (1년 전)
    @Persisted var nProfitThr: Int? // 당기순이익 (3년 전)
    @Persisted var nProfitTwo: Int? // 당기순이익 (2년 전)
    @Persisted var nProfitOne: Int? // 당기순이익 (1년 전)
    @Persisted var totalDebtThr: Int? // 부채총계 (3년 전)
    @Persisted var totalDebtTwo: Int? // 부채총계 (2년 전)
    @Persisted var totalDebtOne: Int? // 부채총계 (1년 전)
    @Persisted var totalCapThr: Int? // 자본총계 (3년 전)
    @Persisted var totalCapTwo: Int? // 자본총계 (2년 전)
    @Persisted var totalCapOne: Int? // 자본총계 (1년 전)
    // divi info
    @Persisted var dpsThr: Int? // 주당배당금 (3년 전)
    @Persisted var dpsTwo: Int? // 주당배당금 (2년 전)
    @Persisted var dpsOne: Int? // 주당배당금 (1년 전)
    @Persisted var diviPayoutRatioThr: Double? // 배당성향 (3년 전)
    @Persisted var diviPayoutRatioTwo: Double? // 배당성향 (2년 전)
    @Persisted var diviPayoutRatioOne: Double? // 배당성향 (1년 전)
    //opinion
    @Persisted var regDate = Date()  // 등록 날짜(필수)
    @Persisted var opinion: String? // 개인 의견
    @Persisted var buyPricePlan: Int? // 매수 희망가
    @Persisted var buyDatePlan = Date() // 매수 희망일
    @Persisted var sellPricePlan : Int? // 매도 희망가
    @Persisted var sellDatePlan = Date() // 매도 희망일

    @Persisted var tradingDiaries: List<TradingDiaryRealmModel>
    
    @Persisted(primaryKey: true) var objectId: ObjectId

    convenience init(formalCorpName: String, updateDate: Date, corpName: String, marketName: String, srtnCode: String, nowPrice: Int, highPrice: Int, lowPrice: Int, tradingQnt: Int, totAmt: Int, revenueThr: Int?, revenueTwo: Int?, revenueOne: Int?, opIncomeThr: Int?, opIncomeTwo: Int?, opIncomeOne: Int?, nProfitThr: Int?, nProfitTwo: Int?, nProfitOne: Int?, totalDebtThr: Int?, totalDebtTwo: Int?, totalDebtOne: Int?, totalCapThr: Int?, totalCapTwo: Int?, totalCapOne: Int?, dpsThr: Int?, dpsTwo: Int?, dpsOne: Int?, diviPayoutRatioThr: Double?, diviPayoutRatioTwo: Double?, diviPayoutRatioOne: Double?, regDate: Date, opinion: String?, buyPricePlan: Int?, buyDatePlan: Date, sellPricePlan : Int?, sellDatePlan: Date) {
        
        self.init()
        self.formalCorpName = formalCorpName
        // 종합 데이터
        self.updateDate = updateDate
        self.corpName = corpName
        self.marketName = marketName
        self.srtnCode = srtnCode
        self.nowPrice = nowPrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.tradingQnt = tradingQnt
        self.totAmt = totAmt
        // 재무 데이터
        self.revenueThr = revenueThr
        self.revenueTwo = revenueTwo
        self.revenueOne = revenueOne
        self.opIncomeThr = opIncomeThr
        self.opIncomeTwo = opIncomeTwo
        self.opIncomeOne = opIncomeOne
        self.nProfitThr = nProfitThr
        self.nProfitTwo = nProfitTwo
        self.nProfitOne = nProfitOne
        self.totalDebtThr = totalDebtThr
        self.totalDebtTwo = totalDebtTwo
        self.totalDebtOne = totalDebtOne
        self.totalCapThr = totalCapThr
        self.totalCapTwo = totalCapTwo
        self.totalCapOne = totalCapOne
        // 배당 데이터
        self.dpsThr = dpsThr
        self.dpsTwo = dpsTwo
        self.dpsOne = dpsOne
        self.diviPayoutRatioThr = diviPayoutRatioThr
        self.diviPayoutRatioTwo = diviPayoutRatioTwo
        self.diviPayoutRatioOne = diviPayoutRatioOne
        // My Opinion
        self.regDate = regDate
        self.opinion = opinion
        self.buyPricePlan = buyPricePlan
        self.buyDatePlan = buyDatePlan
        self.sellPricePlan = sellPricePlan
        self.sellDatePlan = sellDatePlan
    }

}









