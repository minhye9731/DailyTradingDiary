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
    
    func filterSelectedCrop(searchText: String) -> String
    
    func plusCorpCode(item: [CorpCodeRealmModel])
//    func deleteAllItem()
    
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
    
    func filterSelectedCrop(searchText: String) -> String {
        tasks = CorpCodeRepository.standard.localRealm.objects(CorpCodeRealmModel.self).where { $0.stockCode == searchText }
        return tasks[0].corpCode
    }
    
    // MARK: - 추가 / 삭제 / 업데이트
    
    // 전체 삭제 & 추가
    func plusCorpCode(item: [CorpCodeRealmModel]) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        
        DispatchQueue.global().async {
            let startTime = CFAbsoluteTimeGetCurrent()
            let realm = try! Realm()
            
            autoreleasepool {
                
                try! realm.write({
                    realm.add(item)
                })
                
            }
            print("=========(상장기업 한정) 데이터 realm에 저장 완료 / onComplete :======== \(CFAbsoluteTimeGetCurrent() - startTime)")
        }
        
        
        ////        do {
        ////            try localRealm.write{
        ////                let allItems = self.localRealm.objects(CorpCodeRealmModel.self)
        ////                self.localRealm.delete(allItems)
        ////                localRealm.add(item)
        ////                print("(상장기업 한정) 데이터 realm에 저장 완료 ✅: \(CFAbsoluteTimeGetCurrent() - startTime)")
        ////            }
        //
        //        //try
        //        // <background write>
        //        localRealm.writeAsync {
        //                // 기존 전체 데이터 삭제 필요
        ////                let allItems = self.localRealm.objects(CorpCodeRealmModel.self)
        ////                self.localRealm.delete(allItems)
        //
        //                self.localRealm.add(item)
        //                print("(상장기업 한정) 데이터 realm에 저장 완료 ✅: \(CFAbsoluteTimeGetCurrent() - startTime)")
        ////            }
        //
        ////            try localRealm.beginAsyncWrite {
        ////                let allItems = self.localRealm.objects(CorpCodeRealmModel.self)
        ////                self.localRealm.delete(allItems)
        ////                self.localRealm.add(item)
        ////                self.localRealm.commitAsyncWrite()
        ////                print("(상장기업 한정) 데이터 realm에 저장 완료 ✅: \(CFAbsoluteTimeGetCurrent() - startTime)")
        ////            }
        //
        //        } onComplete: { _ in
        //            // completion block - write 컴파일이 끝나고 나서(성공이든 실패든) source thread에서 실행되는 메서드
        //            print("=========(상장기업 한정) 데이터 realm에 저장 완료 / onComplete :======== \(CFAbsoluteTimeGetCurrent() - startTime)")
        //        }
        ////        catch let error {
        ////            print(error.localizedDescription)
        ////        }
        //    }
    }

    
}
