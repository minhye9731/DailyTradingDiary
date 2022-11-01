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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
        
        getTotalInput()
        isEmptyCheck()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getPieChart()
            self.mainView.ratioChart.animateChart()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
//        CorpRegisterRepository.standard.fetchRealm()
    }
    
    override func configure() {
        getTotalInput()
    }
    
    func getPieChart() {
        let slideArr = CorpRegisterRepository.standard.getPercentagePerStock()
        
        self.mainView.ratioChart.slices = slideArr.sorted(by: { $0.percent > $1.percent })
    }
    
    func getTotalInput() {
        let totalAmount = CorpRegisterRepository.standard.getTotalInvest()
        mainView.resultLabel.text = "\(thousandSeparatorCommas(value: totalAmount)) \(Constants.CurrencySign.won.rawValue)"
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
