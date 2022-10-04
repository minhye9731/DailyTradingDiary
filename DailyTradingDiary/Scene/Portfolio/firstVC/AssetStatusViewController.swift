//
//  AssetStatusViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import SnapKit
import RealmSwift

class AssetStatusViewController: BaseViewController {
    
    let mainView = AssetStatusView()
    
    override func loadView() {
        print("AssetStatusViewController - \(#function)")
        self.view = mainView
    }

    override func viewDidLoad() {
        print("AssetStatusViewController - \(#function)")
        super.viewDidLoad()
        
        TradingDiaryRepository.standard.fetchRealm()
        isEmptyCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
        
        TradingDiaryRepository.standard.fetchRealm() // 데이터 fetching하고
        isEmptyCheck() // 데이터여부 확인해서 view 선택적용
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getPieChart()
            self.mainView.ratioChart.animateChart()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
    }
    
    override func configure() {
        getTotalInput()
    }
    
    func getPieChart() {
        // 수정필요
        let slideArr = TradingDiaryRepository.standard.getPercentagePerStock()
        self.mainView.ratioChart.slices = slideArr.sorted(by: { $0.percent > $1.percent })
    }
    
    func getTotalInput() {
        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
    
        mainView.resultLabel.text = "\(thousandSeparatorCommas(value: buyTotalAmount)) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func isEmptyCheck() {
        if TradingDiaryRepository.standard.tasks.count == 0 {
            self.mainView.ratioChart.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            self.mainView.ratioChart.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }
    

}
