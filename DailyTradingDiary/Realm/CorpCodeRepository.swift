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
    
    func filteredRegisterMode(searchText: String)
    func filteredTradingMode(searchText: String)
    
    func plusCorpCode(item: [CorpCodeRealmModel])
    func deleteAllItem()
}

class CorpCodeRepository: CorpCodeRepositoryType {
    
    private init() {}
    static let standard = CorpCodeRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpCodeRealmModel>!
    
    // MARK: - 데이터 패치
    func fetchRealmRegisterMode() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.stockCode != " " }
        print("fetchRealmRegisterMode - \(tasks.count)")
    }
    
    func fetchRealmTradingMode() {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.isRegistered == true && $0.stockCode != " " }
        print("fetchRealmTradingMode - \(tasks.count)")
    }
    
    // MARK: - 실시간 검색시
    func filteredRegisterMode(searchText: String) {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where {
            ($0.stockCode != " "  && $0.corpName == searchText) || ($0.stockCode != " "  && $0.stockCode == searchText)
        }
        print("filteredRegisterMode - \(tasks.count)")
    }
    
    func filteredTradingMode(searchText: String) {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where {
            $0.isRegistered == true && ($0.stockCode != " "  && $0.corpName == searchText) || ($0.stockCode != " "  && $0.stockCode == searchText)
        }
        print("filteredTradingMode - \(tasks.count)")
    }
    
    // MARK: - 추가 / 삭제 / 업데이트
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
