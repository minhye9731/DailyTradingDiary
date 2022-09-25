//
//  NetworkResult.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/26/22.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
