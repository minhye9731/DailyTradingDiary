//
//  KRXListResponse.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/26/22.
//

import Foundation
//
//struct KRXListResponse: Decodable {
//    let response: Response
//}
//
//struct Response: Decodable {
//    let header: Header
//    let body: Body
//}
//
//struct Body: Decodable {
//    let numOfRows, pageNo, totalCount: Int
//    let items: Items
//}
//
//struct Items: Decodable {
//    let item: [Item]
//}
//
//struct Item: Decodable {
//    let basDt, srtnCD, isinCD, mrktCtg: String
//    let itmsNm, crno, corpNm: String
//
//    enum CodingKeys: String, CodingKey {
//        case basDt
//        case srtnCD = "srtnCd"
//        case isinCD = "isinCd"
//        case mrktCtg, itmsNm, crno, corpNm
//    }
//}
//
//struct Header: Decodable {
//    let resultCode, resultMsg: String
//}
