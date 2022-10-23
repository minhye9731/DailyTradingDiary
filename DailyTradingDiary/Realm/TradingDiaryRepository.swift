//
//  TradingDiaryRepository.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/17/22.
//

import Foundation
import RealmSwift
import UIKit

protocol DiaryRepositoryType {
    func fetchRealm()
    
    func filteredByTradingDate(selectedDate: Date)
    func sortByRegDate()
    func sort(_ sort: String) -> Results<TradingDiaryRealmModel>
    
    func getTotalBuyPrice(from: Date, to: Date) -> Int
    func getTotalSellPrice(from: Date, to: Date) -> Int
    
    func calculateRemainAmountWrite(newTrade: TradingDiaryRealmModel) -> Int
    func calculateRemainAmountEdit(originTrade: TradingDiaryRealmModel, newTrade: UpdateTradingDiaryDTO) -> Int
    
    func getPercentagePerStock() -> [newVersionSlice]
    func makeRandomColor() -> UIColor
    
    func filteredByAllTrading(from: Date, to: Date, buySellIndex: Int)
}

class TradingDiaryRepository: DiaryRepositoryType {

    private init() { }
    static let standard = TradingDiaryRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<TradingDiaryRealmModel>!
    
    let calendar = Calendar.current
    
    
    // 데이터 패치하기
    func fetchRealm() {
        tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self)
    }
    
    // home화면 - 선택일자 기준표기용 필터
    func filteredByTradingDate(selectedDate: Date) {
        tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where {
            $0.tradingDate >= calendar.startOfDay(for: selectedDate) && $0.tradingDate < calendar.startOfDay(for: selectedDate) + 86400
        }
    }

    func sortByRegDate() {
        tasks = localRealm.objects(TradingDiaryRealmModel.self).sorted(byKeyPath: "regDate", ascending: true)
    }
    
    func sort(_ sort: String) -> Results<TradingDiaryRealmModel> {
        print(#function)
        return localRealm.objects(TradingDiaryRealmModel.self).sorted(byKeyPath: sort, ascending: true)
    }

    
    // MARK: - 매매내역 조회조건값에 따른 매매총액 계산기
    func getTotalBuyPrice(from: Date, to: Date) -> Int {
         let result = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.tradingDate >= calendar.startOfDay(for: from) && ($0.tradingDate <= calendar.startOfDay(for: to) + 86400) && $0.buyAndSell == false }.map{ $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return result
    }
    
    // 매매내역 작성시 매도금액 제한용
    func calculateRemainAmountWrite(newTrade: TradingDiaryRealmModel) -> Int {
        let buyTotal = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.corpCode == newTrade.corpCode && $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        
        let sellTotal = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.corpCode == newTrade.corpCode && $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        
        let newSellAmount = newTrade.tradingPrice * newTrade.tradingAmount
        
        let updateRemain = buyTotal - sellTotal - newSellAmount
        print("updateRemain: \(updateRemain) = buyTotal \(buyTotal) - sellTotal \(sellTotal) - newSellAmount \(newSellAmount)")
        
        return updateRemain
    }
    
    func calculateRemainAmountEdit(originTrade: TradingDiaryRealmModel, newTrade: UpdateTradingDiaryDTO) -> Int {
        let buyTotalUpdate = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.corpCode == newTrade.corpCode && $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +) - (originTrade.tradingPrice * originTrade.tradingAmount)
        
        let sellTotal = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.corpCode == newTrade.corpCode && $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        
        let newSellAmount = newTrade.tradingPrice * newTrade.tradingAmount
        
        let updateRemain = buyTotalUpdate - sellTotal - newSellAmount
        print("updateRemain: \(updateRemain) = buyTotalUpdate \(buyTotalUpdate) - sellTotal \(sellTotal) - newSellTotal \(newSellAmount)")
        
        return updateRemain
    }
    
    
    
    
    func getTotalSellPrice(from: Date, to: Date) -> Int {
         let result = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where { $0.tradingDate >= calendar.startOfDay(for: from) && ($0.tradingDate <= calendar.startOfDay(for: to) + 86400) && $0.buyAndSell == true }.map{ $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return result
    }

    // 매수한 종목별 퍼센트 및 색상 뱉기
    func getPercentagePerStock() -> [newVersionSlice] {
        let buyTotalAmount: Double = Double(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +))
        print("buyTotalAmount - \(buyTotalAmount)")

        let realmSliceArr: [newVersionSlice] = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where {
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
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400
            }.sorted(byKeyPath: "regDate", ascending: true)
        case 1:
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400 && $0.buyAndSell == false
            }.sorted(byKeyPath: "regDate", ascending: true)
        case 2:
            tasks = TradingDiaryRepository.standard.localRealm.objects(TradingDiaryRealmModel.self).where {
                $0.tradingDate >= calendar.startOfDay(for: from) && $0.tradingDate <= calendar.startOfDay(for: to) + 86400 && $0.buyAndSell == true
            }.sorted(byKeyPath: "regDate", ascending: true)
        default : break
        }
    }

}
