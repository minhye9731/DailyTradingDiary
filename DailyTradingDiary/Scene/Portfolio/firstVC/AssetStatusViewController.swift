//
//  AssetStatusViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import SnapKit
import RealmSwift

final class AssetStatusViewController: BaseViewController {
    
    // MARK: - property
    private let mainView = AssetStatusView()
    private let totalAmount = CorpRegisterRepository.standard.getTotalInvest()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isEmptyCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTotalInput()
        isEmptyCheck()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            CorpRegisterRepository.standard.fetchRealm()
            self.getPieChart()
            self.mainView.ratioChart.animateChart()
        }
    }
    
    // MARK: - functions
    override func configure() {
        getTotalInput()
    }
    
    func getPieChart() {
        let slideArr = CorpRegisterRepository.standard.getPercentagePerStock()
        self.mainView.ratioChart.slices = slideArr.sorted(by: { $0.percent > $1.percent })
    }
    
    func getTotalInput() {
        mainView.resultLabel.text = "\(thousandSeparatorCommas(value: totalAmount)) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func isEmptyCheck() {
        if totalAmount == 0 {
            self.mainView.ratioChart.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            self.mainView.ratioChart.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }
    

}
