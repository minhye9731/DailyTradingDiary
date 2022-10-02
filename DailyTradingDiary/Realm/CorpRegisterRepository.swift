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
    
    func updateDiaryatList(oldItem: TradingDiaryRealmModel, newItem: UpdateTradingDiaryDTO)
    
    func deleteRegisteredCorp(item: CorpRegisterRealmModel)
    
    func isRegistered(item: KRXListDTO) -> Bool
}


class CorpRegisterRepository: RegisterRepositoryType {
    
    private init() { }
    static let standard = CorpRegisterRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpRegisterRealmModel>!
    
    
    func updateDiaryatList(oldItem: TradingDiaryRealmModel, newItem: UpdateTradingDiaryDTO) {
        
        do {
            try localRealm.write {
                oldItem.corpName = newItem.corpName
                oldItem.tradingPrice = newItem.tradingPrice
                oldItem.tradingAmount = newItem.tradingAmount
                oldItem.buyAndSell = newItem.buyAndSell
                oldItem.tradingDate = newItem.tradingDate
                oldItem.tradingMemo = newItem.tradingMemo

                oldItem.regDate = newItem.regDate
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
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
            
//            .filter { $0.srtnCode == item.corpCode }.first! // 이렇게 하면 옵셔널 언래핑할때 런타임 오류남
        
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
