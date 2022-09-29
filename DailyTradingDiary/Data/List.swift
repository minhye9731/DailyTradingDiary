//
//  List.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/30/22.
//

import Foundation
import SWXMLHash

struct List: XMLObjectDeserialization {
    let corp_code: String
    let corp_name: String
    let stock_code: String?
    let modify_date: String

    static func deserialize(_ element: XMLIndexer) throws -> List {
        return try List(
            corp_code: element["corp_code"].value(),
            corp_name: element["corp_name"].value(),
            stock_code: element["stock_code"].value(),
            modify_date: element["modify_date"].value()
        )
    }
}
