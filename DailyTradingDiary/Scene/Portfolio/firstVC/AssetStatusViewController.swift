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
        
        isEmptyCheck()
        TradingDiaryRepository.standard.fetchRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
        isEmptyCheck()
        self.mainView.ratioChart.animateChart()
    }
    
    override func configure() {
        getTotalInput()
        getPieChart()
    }
    
    func getPieChart() {
        // realm데이터를 넣어야 해서 뷰컨에 있어야 함.
        self.mainView.ratioChart.slices = [newVersionSlice(percent: 0.4, color: UIColor.systemRed),
                               newVersionSlice(percent: 0.3, color: UIColor.systemTeal),
                               newVersionSlice(percent: 0.2, color: UIColor.systemRed),
                               newVersionSlice(percent: 0.1, color: UIColor.systemIndigo)]
        
        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
    }
    
    func getTotalInput() {
        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        mainView.investmentValueLabel.text = "\(buyTotalAmount) \(Constants.CurrencySign.won.rawValue)"
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
