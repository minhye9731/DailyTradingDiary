//
//  AlphaModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import Foundation

struct MarketNewsModel {
    let title : String // 기사 제목
    let url : String //기사 url
    let publishedDate : String // 기사 출간 일자
    let profileImageUrl : String
    let source : String // 출처
    let topic : String // 대표 주제
    let relatedTicker : String // 관련기업 대표 티커
}
