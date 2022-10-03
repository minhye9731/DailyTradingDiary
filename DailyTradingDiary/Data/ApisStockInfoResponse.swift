//
//  APISStockInfoResponse.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation

// 공공데이터 주식시세 (기업등록 > summary에 들어갈 주식정보 데이터 받는 response)
struct APISStockInfoResponse: Decodable {
    let response: Response
}

// MARK: - Response
struct Response: Decodable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Decodable {
    let numOfRows, pageNo, totalCount: Int
    let items: Items
}

// MARK: - Items
struct Items: Decodable {
    let item: [Item]
}

// MARK: - Item
struct Item: Decodable {
    let basDt, srtnCD, isinCD, itmsNm: String
    let mrktCtg, clpr, vs, fltRt: String
    let mkp, hipr, lopr, trqu: String
    let trPrc, lstgStCnt, mrktTotAmt: String

    enum CodingKeys: String, CodingKey {
        case basDt
        case srtnCD = "srtnCd"
        case isinCD = "isinCd"
        case itmsNm, mrktCtg, clpr, vs, fltRt, mkp, hipr, lopr, trqu, trPrc, lstgStCnt, mrktTotAmt
    }
}

// MARK: - Header
struct Header: Decodable {
    let resultCode, resultMsg: String
}
