//
//  CorpRegisterRepository.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/2/22.
//

import Foundation
import RealmSwift
import UIKit

protocol RegisterRepositoryType {
    func fetchRealm()
    func sortByRegDate()
    
    func plusRegisterCorp(item: CorpRegisterRealmModel)
    func plusDiaryatList(item: TradingDiaryRealmModel)
    
    func diaryInListupdate(updateTarget: TradingDiaryRealmModel, updateData: UpdateTradingDiaryDTO)
    
    
    func deleteRegisteredCorp(item: CorpRegisterRealmModel)
    
    func isRegistered(item: KRXListDTO) -> Bool
}


class CorpRegisterRepository: RegisterRepositoryType {
    
    private init() { }
    static let standard = CorpRegisterRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpRegisterRealmModel>!

    
    // 데이터 패치하기
    func fetchRealm() {
        tasks = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self)
    }
    
    // 등록일자 기준 정렬
    func sortByRegDate() {
        tasks = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).sorted(byKeyPath: "regDate", ascending: true)
    }
    
    // 기업 신규등록
    func plusRegisterCorp(item: CorpRegisterRealmModel) {
        do {
            try localRealm.write{
                localRealm.add(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    // 매매일지 list로 추가 (strn 코드로 parent 찾아가기)
    func plusDiaryatList(item: TradingDiaryRealmModel) {
        
        let corp = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).where{ $0.corpName == item.corpName }
        
        print("corp = \(corp)")
        
        do {
            try localRealm.write{
                corp.first?.tradingDiaries.append(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    // 매매일지 list 수정 추가
    func diaryInListupdate(updateTarget: TradingDiaryRealmModel, updateData: UpdateTradingDiaryDTO) {
        
        let updateDiary = TradingDiaryRealmModel()
        updateDiary.objectId = updateTarget.objectId

        updateDiary.corpName = updateData.corpName
        updateDiary.corpCode = updateData.corpCode
        updateDiary.tradingPrice = updateData.tradingPrice
        updateDiary.tradingAmount = updateData.tradingAmount
        updateDiary.buyAndSell = updateData.buyAndSell
        updateDiary.regDate = updateData.regDate
        updateDiary.tradingDate = updateData.tradingDate
        updateDiary.tradingMemo = updateData.tradingMemo
        
        do {
            try localRealm.write {
                CorpRegisterRepository.standard.localRealm.add(updateDiary, update: .modified)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    
    // 등록기업 삭제 (연관된 매매일지도 함께 삭제되려나..?)
    func deleteRegisteredCorp(item: CorpRegisterRealmModel) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    // 포함여부 확인 (검색화면)
    func isRegistered(item: KRXListDTO) -> Bool {
        
        let registeredSRTNCrop = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).where {
            return $0.srtnCode.in([item.srtnCode])
        }
        
        print("포함여부 확인 : \(registeredSRTNCrop.count)")
        print("registeredSRTNCrop : \(registeredSRTNCrop)")
        return registeredSRTNCrop.count == 1
        
    }
    
    
}
