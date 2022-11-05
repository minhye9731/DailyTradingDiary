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
    func deleteDiaryatList(item: TradingDiaryRealmModel)
    
    func isRegistered(item: KRXListDTO) -> Bool
    
    func getTotalInvest() -> Int
    
    func buyArrPerCorp() -> [Int]
    func sellArrPerCorp() -> [Int]
    
    func getPercentagePerStock() -> [newVersionSlice]
    func makeRandomColor() -> UIColor
    
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
            print(error)
        }
    }
    
    // 매매일지 list 추가 (strn 코드로 parent 찾아가기)
    func plusDiaryatList(item: TradingDiaryRealmModel) {
        
        let corp = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).where{ $0.corpName == item.corpName }
        
        do {
            try localRealm.write{
                corp.first?.tradingDiaries.append(item)
            }
        } catch let error {
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
            print(error)
        }
    }
    
    // 매매일지 list 삭제
    func deleteDiaryatList(item: TradingDiaryRealmModel) {
        do {
            try localRealm.write {
                CorpRegisterRepository.standard.localRealm.delete(item)
            }
        } catch let error {
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
    
    
    // 현재 총 자산
    func getTotalInvest() -> Int {
        
        // 각 등록기업의 총 매수금액 합계
        let buyTotal = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { $0.tradingDiaries.filter { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) }.reduce(0, +)
        
        // 각 등록기업의 총 매도금액 합계
        let sellTotal = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { $0.tradingDiaries.filter { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) }.reduce(0, +)
        
        let result = buyTotal - sellTotal
        print("result \(result) = buyTotal \(buyTotal) - sellTotal \(sellTotal)")
        
        return result
    }
    
    // 각 등록기업별 총 매수금액 배열
    func buyArrPerCorp() -> [Int] {
        let buyTotal: [Int] = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { $0.tradingDiaries.filter { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) }
        
        print("각 등록기업별 총 매수금액 배열 = \(buyTotal)")
        
        return buyTotal
    }
    
    // 각 등록기업별 총 매도금액 배열
    func sellArrPerCorp() -> [Int] {
        let sellTotal: [Int] = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { $0.tradingDiaries.filter { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) }
        
        print("각 등록기업별 총 매도금액 배열 = \(sellTotal)")
        
        return sellTotal
    }
    
    
    // 매수한 종목별 퍼센트 및 색상 뱉기
    func getPercentagePerStock() -> [newVersionSlice] {
        
        var realmSliceArr: [newVersionSlice] = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map {
            
            let remain = $0.tradingDiaries.filter { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) - $0.tradingDiaries.filter { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
            
            let corpName = $0.formalCorpName
            let percent: Double = Double(remain) / Double(getTotalInvest())
            let color = makeRandomColor()
            
//            return newVersionSlice(percent: CGFloat(percent), color: color)
            return newVersionSlice(name: corpName, percent: CGFloat(percent), color: color)
        }
        dump(realmSliceArr)
        return realmSliceArr
    }

    func makeRandomColor() -> UIColor {
        let r : CGFloat = CGFloat.random(in: 0.2...0.6)
        let g : CGFloat = CGFloat.random(in: 0.2...0.8)
        let b : CGFloat = CGFloat.random(in: 0.7...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    
}
