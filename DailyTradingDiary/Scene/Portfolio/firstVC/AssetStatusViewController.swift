//
//  AssetStatusViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import SnapKit

class AssetStatusViewController: BaseViewController {
    
    let mainView = AssetStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        self.view.backgroundColor = .systemBlue
        
//        self.mainView.ratioChart.animateChart()
        
        pleaseeeeee()
//        presentCircleView()
    }
    
    
    
    
    
    func pleaseeeeee() {
        
        // realm데이터를 넣어야 해서 뷰컨에도 있어야 함.
        self.mainView.ratioChart.slices = [newVersionSlice(percent: 0.4, color: UIColor.systemOrange),
                               newVersionSlice(percent: 0.3, color: UIColor.systemTeal),
                               newVersionSlice(percent: 0.2, color: UIColor.systemRed),
                               newVersionSlice(percent: 0.1, color: UIColor.systemIndigo)]
        self.mainView.ratioChart.animateChart()
        
        
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
    

}
