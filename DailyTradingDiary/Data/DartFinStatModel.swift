//
//  DartFinStatModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation

struct DartFinStatModel : Decodable {
    let sjName : String // 구분
    let labelID : String // 항목 ID
    let labelName : String // 항목명
    
    let amount_1yr_bf : String // 수치(1년 전)
    let amount_2yr_bf : String // 수치(2년 전)
    let amount_3yr_bf : String // 수치(3년 전)
}
