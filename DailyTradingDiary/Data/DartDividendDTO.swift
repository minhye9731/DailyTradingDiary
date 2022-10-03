//
//  DartDividendModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation


//struct DartFinInfoDTO : Decodable {
//    let sjName : String // 구분
//    let labelID : String // 항목 ID
//    let labelName : String // 항목명
//
//    let amount_1yr_bf : String // 수치(1년 전)
//    let amount_2yr_bf : String // 수치(2년 전)
//    let amount_3yr_bf : String // 수치(3년 전)
//}

struct DartDividendDTO : Decodable {
//   let dps_1yr_bf : String // 주당 현금배당금(1년 전)
//   let dps_2yr_bf : String // 주당 현금배당금(2년 전)
//   let dps_3yr_bf : String // 주당 현금배당금(3년 전)
//
//   let dividend_payout_ratio_1yr_bf : String // 배당성향(1년 전)
//   let dividend_payout_ratio_2yr_bf : String // 배당성향(2년 전)
//   let dividend_payout_ratio_3yr_bf : String // 배당성향(3년 전)
    
    let labelName : String // 항목명
    let stockKind : String? // 주식 종류
    
    let amount_1yr_bf : String // 수치(1년 전)
    let amount_2yr_bf : String // 수치(2년 전)
    let amount_3yr_bf : String // 수치(3년 전)
}
