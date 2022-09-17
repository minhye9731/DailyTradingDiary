//
//  UserMemoRepository.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation
import RealmSwift

protocol DiaryRepositoryType {
    func sort(_ sort: String) -> Results<TradingDiary>
    func update(oldItem: TradingDiary, newItem: TradingDiary)
    func plusDiary(item: TradingDiary)
    func deleteDiary(item: TradingDiary)
    
    
}

class DiaryRepository: DiaryRepositoryType {

    let localRealm = try! Realm()
    
    func sort(_ sort: String) -> Results<TradingDiary> {
        print(#function)
        return localRealm.objects(TradingDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func update(oldItem: TradingDiary, newItem: TradingDiary) {
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
    
    // MARK: - 추가 및 삭제
    func plusDiary(item: TradingDiary) {
        do {
            try localRealm.write{
                localRealm.add(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func deleteDiary(item: TradingDiary) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
}

