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
    func fetchRealm()
    func filteredByStockCodeExistence()
    func plusCorpCode(item: [CorpCodeRealmModel])
    func deleteAllItem()
}

class CorpCodeRepository: CorpCodeRepositoryType {
    
    private init() {}
    static let standard = CorpCodeRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpCodeRealmModel>!
    
    // 데이터 패치하기
    func fetchRealm() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self)
    }
    
    func filteredByStockCodeExistence() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.stockCode != "" }
    }
    
    func plusCorpCode(item: [CorpCodeRealmModel]) {
        do {
            try localRealm.write{
                localRealm.add(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    // 전체삭제
    func deleteAllItem() {
        do {
            try localRealm.write{
                let allItems = localRealm.objects(CorpCodeRealmModel.self)
                localRealm.delete(allItems)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
}
