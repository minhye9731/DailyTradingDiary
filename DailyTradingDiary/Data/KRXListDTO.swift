//
//  KRXListDTO.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/2/22.
//

import Foundation

struct KRXListDTO: Decodable {
    let itemName: String
    let corpName: String
    let marketName: String
    let srtnCode: String
    let isinCode: String
}
