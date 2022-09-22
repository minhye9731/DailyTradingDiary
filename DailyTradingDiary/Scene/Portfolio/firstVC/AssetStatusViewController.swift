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

        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        mainView.investmentValueLabel.text = "\(buyTotalAmount) \(Constants.CurrencySign.won.rawValue)"
        
        getPieChart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("AssetStatusViewController - \(#function)")
    }
    
    func getPieChart() {
        
        // realm데이터를 넣어야 해서 뷰컨에 있어야 함.
        self.mainView.ratioChart.slices = [newVersionSlice(percent: 0.4, color: UIColor.systemOrange),
                               newVersionSlice(percent: 0.3, color: UIColor.systemTeal),
                               newVersionSlice(percent: 0.2, color: UIColor.systemRed),
                               newVersionSlice(percent: 0.1, color: UIColor.systemIndigo)]
        self.mainView.ratioChart.animateChart()
    }
    
    func eee() {
        // 매수/매도로 우선 구분
        // 매수한 모든 종목별 '총 매입금액'을 계산
        // 매수종목과 동일한 이름의 매도기록이 있다면, 해당 금액들의 '총 매도금액'을 계산해서 매수한 쪽에 마이너스를 해줌.
        TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
    }
    
//    private func presentCircleView() {
//        let width = self.mainView.chartView.frame.width
//        let height = self.mainView.chartView.frame.height
//
//        let pieChartView = PortfolioChartView(frame: CGRect(x: 0, y: 0, width: width, height: height)) // x, y값 수정해야 하려나?
//        pieChartView.center = self.mainView.chartView.center
//
//        // 슬라이드 조각들은 realm 에 들어온 데이터들을 slice 데이터모델에 맞추어서 생성되도록 map 할 예정
//        pieChartView.slices = [newVersionSlice(percent: 0.4, color: UIColor.systemOrange),
//                               newVersionSlice(percent: 0.3, color: UIColor.systemTeal),
//                               newVersionSlice(percent: 0.2, color: UIColor.systemRed),
//                               newVersionSlice(percent: 0.1, color: UIColor.systemIndigo)]
//
//        self.mainView.chartView.addSubview(pieChartView)
//
//        pieChartView.animateChart()
//    }
    
    
    func calculateTotalInput() {
        
        
//        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        
//        let sellTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        
        
    }
    

}
