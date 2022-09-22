//
//  AssetStatusView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit

final class AssetStatusView: BaseView {
    
    // MARK: - resultView
    let resultView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    // 총 자산(평가금액)
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "99,999 \(Constants.CurrencySign.won.rawValue)" // 뷰컨에서 전달예정
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    // 투자원금
    let investmentLabel: UILabel = {
        let label = UILabel()
        label.text = "투자원금"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let investmentValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 평가손익
    let gainLossLabel: UILabel = {
        let label = UILabel()
        label.text = "평가손익"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let gainLossValueLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 22,222 \(Constants.CurrencySign.won.rawValue)" // 뷰컨에서 전달예정
        label.textColor = .systemRed // 뷰컨에서 로직걸기
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 수익률
    let earningsRateLabel: UILabel = {
        let label = UILabel()
        label.text = "수익률"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let earningsRateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 28.57 %" // 뷰컨에서 전달예정
        label.textColor = .systemRed // 뷰컨에서 로직걸기
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - chartView
    let chartView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // 자산비중 라벨
    let ratioLabel: UILabel = {
        let label = UILabel()
        label.text = "자산구성"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var ratioChart: PortfolioChartView = {
        let pieChartView = PortfolioChartView(frame: CGRect(x: self.chartView.frame.width / 2, y: self.chartView.frame.height / 2, width: 100, height: 100))
        return pieChartView
    }()
    
    override func configureUI() {
        

        
//        let pieWidth = self.chartView.frame.width
//        let pieHeight = self.chartView.frame.height
//
//        let pieChartView = PortfolioChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        pieChartView.slices = [newVersionSlice(percent: 0.4, color: UIColor.systemOrange),
//                               newVersionSlice(percent: 0.3, color: UIColor.systemTeal),
//                               newVersionSlice(percent: 0.2, color: UIColor.systemRed),
//                               newVersionSlice(percent: 0.1, color: UIColor.systemIndigo)]
//        chartView.addSubview(pieChartView)
//        pieChartView.animateChart()
        
        [resultView, chartView].forEach {
            self.addSubview($0)
        }
        
        [resultLabel, investmentLabel, investmentValueLabel, gainLossLabel, gainLossValueLabel, earningsRateLabel, earningsRateValueLabel].forEach {
            resultView.addSubview($0)
        }
        
        [ratioLabel, grayline, ratioChart].forEach {
            chartView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        // MARK: - resultView
        resultView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.resultView)
            make.top.equalTo(resultView.snp.top).offset(20)
        }
        
        // 투자원금
        investmentLabel.snp.makeConstraints { make in
            make.leading.equalTo(resultView.snp.leading).offset(14)
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
        }
        investmentValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(resultView.snp.trailing).inset(14)
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
        }
        
        // 평가손익
        gainLossLabel.snp.makeConstraints { make in
            make.leading.equalTo(resultView.snp.leading).offset(14)
            make.top.equalTo(investmentLabel.snp.bottom).offset(16)
        }
        gainLossValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(resultView.snp.trailing).inset(14)
            make.top.equalTo(investmentValueLabel.snp.bottom).offset(16)
        }
        
        // 수익률
        earningsRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(resultView.snp.leading).offset(14)
            make.top.equalTo(gainLossLabel.snp.bottom).offset(16)
        }
        earningsRateValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(resultView.snp.trailing).inset(14)
            make.top.equalTo(gainLossValueLabel.snp.bottom).offset(16)
        }
        
        // MARK: - chartView
        chartView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        grayline.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.top).offset(10)
            make.leading.trailing.equalTo(self.chartView).inset(14)
            make.height.equalTo(1)
        }
        
        ratioLabel.snp.makeConstraints { make in
            make.leading.equalTo(chartView.snp.leading).offset(14)
            make.top.equalTo(grayline.snp.bottom).offset(14)
        }
        
        ratioChart.snp.makeConstraints { make in
            make.center.equalTo(chartView.snp.center)
            make.width.equalTo(chartView.snp.width)
            make.height.equalTo(chartView.snp.height)
        }
    }
    
}
