//
//  DartDividendModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation

struct DartDividendDTO : Decodable {
   let dps_1yr_bf : String // 주당 현금배당금(1년 전)
   let dps_2yr_bf : String // 주당 현금배당금(2년 전)
   let dps_3yr_bf : String // 주당 현금배당금(3년 전)

   let dividend_payout_ratio_1yr_bf : String // 배당성향(1년 전)
   let dividend_payout_ratio_2yr_bf : String // 배당성향(2년 전)
   let dividend_payout_ratio_3yr_bf : String // 배당성향(3년 전)
}
