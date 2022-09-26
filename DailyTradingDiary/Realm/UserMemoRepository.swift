//
//  UserMemoRepository.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation
import RealmSwift
import UIKit

protocol DiaryRepositoryType {
    func fetchRealm()
    func sortByRegDate()
    func filteredByTradingDate(selectedDate: Date)
    func filteredByAllTrading(from: Date, to: Date, buySellIndex: Int)
    
    func sort(_ sort: String) -> Results<TradingDiary>
    func update(oldItem: TradingDiary, newItem: UpdateTradingDiary)
    func plusDiary(item: TradingDiary)
    func deleteDiary(item: TradingDiary)
}

class TradingDiaryRepository: DiaryRepositoryType {

    // 싱글톤
    private init() { }
    static let standard = TradingDiaryRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<TradingDiary>!
    
    let calendar = Calendar.current
    
    
    // 데이터 패치하기
    func fetchRealm() {
        tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self)
    }
    
    func sortByRegDate() {
        tasks = localRealm.objects(TradingDiary.self).sorted(byKeyPath: "regDate", ascending: true)
    }
    
    func filteredByTradingDate(selectedDate: Date) {
        tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where {
            $0.tradingDate >= calendar.startOfDay(for: selectedDate) && $0.tradingDate < calendar.startOfDay(for: selectedDate) + 86400
        }
    }
    
    
    
    func sort(_ sort: String) -> Results<TradingDiary> {
        print(#function)
        return localRealm.objects(TradingDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func update(oldItem: TradingDiary, newItem: UpdateTradingDiary) {
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
    
    // MARK: - 개별요소 업데이트용
    func corpNameUpdate(oldItem: TradingDiary, newItem: String) {
        do {
            try localRealm.write {
                oldItem.corpName = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func tradingPriceUpdate(oldItem: TradingDiary, newItem: Int) {
        do {
            try localRealm.write {
                oldItem.tradingPrice = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func tradingAmountUpdate(oldItem: TradingDiary, newItem: Int) {
        do {
            try localRealm.write {
                oldItem.tradingAmount = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func buyAndSellUpdate(oldItem: TradingDiary, newItem: Bool) {
        do {
            try localRealm.write {
                oldItem.buyAndSell = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func tradingDateUpdate(oldItem: TradingDiary, newItem: Date) {
        do {
            try localRealm.write {
                oldItem.tradingDate = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func tradingMemoUpdate(oldItem: TradingDiary, newItem: String) {
        do {
            try localRealm.write {
                oldItem.tradingMemo = newItem
            }
        } catch let error {
            // 얼럿표시
            print(error)
        }
    }
    
    func regDateUpdate(oldItem: TradingDiary, newItem: Date) {
        do {
            try localRealm.write {
                oldItem.regDate = newItem
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
    
    // MARK: - 매매내역 조회조건값에 따른 매매총액 계산기
    func getTotalBuyPrice(from: Date, to: Date) -> Int {
         let result = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where { $0.tradingDate >= calendar.startOfDay(for: from) && ($0.tradingDate <= calendar.startOfDay(for: to) + 86400) && $0.buyAndSell == false }.map{ $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return result
    }
    
    func getTotalSellPrice(from: Date, to: Date) -> Int {
         let result = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where { $0.tradingDate >= calendar.startOfDay(for: from) && ($0.tradingDate <= calendar.startOfDay(for: to) + 86400) && $0.buyAndSell == true }.map{ $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return result
    }
    
    // ).sorted(byKeyPath: "regDate", ascending: true)
    
    // 매수한 종목별 퍼센트 및 색상 뱉기
    func getPercentagePerStock() -> [newVersionSlice] {
        let buyTotalAmount: Double = Double(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +))
        print("buyTotalAmount - \(buyTotalAmount)")
        
        let realmSliceArr: [newVersionSlice] = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where {
            $0.buyAndSell == false }.map {
                
                let percent: Double = Double($0.tradingPrice) * Double($0.tradingAmount) / buyTotalAmount
                print("percent - \(percent)")
                let color = makeRandomColor()
                
                return newVersionSlice(percent: CGFloat(percent), color: color)
            }
        return realmSliceArr
    }
    
    func makeRandomColor() -> UIColor {
        let r : CGFloat = CGFloat.random(in: 0.2...0.6)
        let g : CGFloat = CGFloat.random(in: 0.2...0.8)
        let b : CGFloat = CGFloat.random(in: 0.7...1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    
    
    // MARK: - 매매내역 조회조건값에 따른 tableview 계산기
    func filteredByAllTrading(from: Date, to: Date, buySellIndex: Int) {
        
        switch buySellIndex {
        case 0:
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400
            }.sorted(byKeyPath: "regDate", ascending: true)
        case 1:
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400 && $0.buyAndSell == false
            }.sorted(byKeyPath: "regDate", ascending: true)
        case 2:
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiary.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400 && $0.buyAndSell == true
            }.sorted(byKeyPath: "regDate", ascending: true)
        default : break
        }
    }
    
}
