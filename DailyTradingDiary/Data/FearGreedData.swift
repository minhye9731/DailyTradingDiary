//
//  FearGreedModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import Foundation

struct FearGreedData {
    let updateTime : String // 업데이트된 시간
    let now : FearGreed
    let weekAgo : FearGreed
}

struct FearGreed {
    let indexValue : Int // 탐욕공포 지수값
    let indexStatus : String // 탐욕공포 지수 상태문구
}
