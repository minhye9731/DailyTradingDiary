//
//  CorpCodeRepository.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/30/22.
//

import Foundation
import RealmSwift
import UIKit

protocol CorpCodeRepositoryType {
    func fetchRealmRegisterMode()
    func fetchRealmTradingMode()
    
    func filterSelectedCrop(srtnCd: String) -> String
    
    func plusCorpCode(item: [XMLListVO])
}

class CorpCodeRepository: CorpCodeRepositoryType {
    
    private init() {}
    static let standard = CorpCodeRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpCodeRealmModel>!
    
    // MARK: - 데이터 패치
    func fetchRealmRegisterMode() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.stockCode != " " }
    }
    
    func fetchRealmTradingMode() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.isRegistered == true }
    }
    
    // MARK: - 실시간 검색시
    
    // 한글기업명 기준으로 dart내
    func filterSelectedCrop(srtnCd: String) -> String {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.stockCode == srtnCd }

        return tasks[0].corpCode
    }
    
    // MARK: - 추가 / 삭제 / 업데이트
    // 전체 삭제 & 추가
    func plusCorpCode(item: [XMLListVO]) {
            let startTime = CFAbsoluteTimeGetCurrent()
        
            let filteredList = item.filter { $0.stock_code != " " }.map {
                let dartCd = $0.corp_code
                let name = $0.corp_name
                let stckCd = $0.stock_code
                let mDate = $0.modify_date
                
                return CorpCodeRealmModel(corpCode: dartCd, corpName: name, stockCode: stckCd, modifyDate: mDate)
            }
            
        try! localRealm.write({
            localRealm.delete(localRealm.objects(CorpCodeRealmModel.self))
            localRealm.add(filteredList)
        })
            print("=========(상장기업 한정) 데이터 realm에 저장 완료 / onComplete ✅ :======== \(CFAbsoluteTimeGetCurrent() - startTime)")
        }
  
}
