//
//  CorpCodeRealmModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/30/22.
//

import Foundation
import RealmSwift

class CorpCodeRealmModel: Object {
    @Persisted var corpCode: String // dart내 고유 기업코드 (필수)
    @Persisted var corpName: String // 기업한글명 (필수)
    @Persisted var stockCode: String? // 공식 기업코드 (옵션)-비상장사 존재
    @Persisted var modifyDate: String // 수정일자 (필수)
    @Persisted var isRegistered: Bool // 관심기업 등록여부 (필수)-기본값 false, 등록하는 순간 true로 변경
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(corpCode: String, corpName: String, stockCode: String?, modifyDate: String) {
        self.init()
        self.corpCode = corpCode
        self.corpName = corpName
        self.stockCode = stockCode
        self.modifyDate = modifyDate
        self.isRegistered = false
    }
    
}
