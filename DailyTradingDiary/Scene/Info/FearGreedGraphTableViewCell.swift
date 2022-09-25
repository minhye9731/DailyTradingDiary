//
//  FearGreedGraphTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import UIKit
import SkeletonView

final class FearGreedGraphTableViewCell: BaseTableViewCell {
    
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "ex) 업데이트 2022.09.19 07:27" // 삭제예정
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    let chartView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    let fearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let greedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let nowValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.isSkeletonable = true
        return label
    }()

    let nowStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 44)
        label.textAlignment = .center
        label.isSkeletonable = true
        return label
    }()
    
    let weekAgoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.isSkeletonable = true
        return label
    }()
    
    
    override func configure() {
        [updateTimeLabel, chartView, fearLabel, greedLabel].forEach {
            contentView.addSubview($0)
        }
        
        [nowValueLabel, nowStatusLabel, weekAgoValueLabel].forEach {
            chartView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        updateTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(22)
        }
        
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(updateTimeLabel.snp.bottom)
            make.height.equalTo(self.frame.width).multipliedBy(0.86)
        }
        
        fearLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(64)
            make.top.equalTo(chartView.snp.bottom)
        }
        
        greedLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-64)
            make.top.equalTo(chartView.snp.bottom)
        }
        
        nowValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        nowStatusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(nowValueLabel.snp.bottom).offset(12)
        }
        
        weekAgoValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(nowStatusLabel.snp.bottom).offset(14)
        }

    }
    
    func setData(data: FearGreedData) {
        print("fearGreedCell의 setData 실행이다~!")
        
        let updateDate = changeFormatDate(data: data.updateTime)
        
        self.updateTimeLabel.text = "UPDATE \(updateDate)"
        self.nowValueLabel.text = "\(data.now.indexValue)"
        self.nowStatusLabel.text = data.now.indexStatus
        self.weekAgoValueLabel.text = "(1주 전: \(data.weekAgo.indexValue), \(data.weekAgo.indexStatus))"
    }
    
    func changeFormatDate(data: String) ->  String {
        
        let index = data.firstIndex(of: "T") ?? data.endIndex
        let begin = data[..<index]
        print("begin: \(begin)")
        
        return begin.replacingOccurrences(of: "-", with:    ".")
    }
    
    func presentCircleView() {
        let width = self.chartView.frame.width // 확인필요
        let height = self.chartView.frame.height // 확인필요
        
//        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        pieChartView.center = self.chartView.center // 확인필요
        
        
        //에러남. 생성코드는 문제없는데, 위치랑 크기잡는게 문제인 듯? 간단하게 생각해보고 재시도해보자.
        let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        pieChartView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.chartView)
        }
        
        
        pieChartView.slices = [Slice(percent: 0.11, color: UIColor.lightGray.withAlphaComponent(0.8), status: "Extreme Fear"),
                               Slice(percent: 0.10, color: UIColor.systemPurple.withAlphaComponent(0.8), status: "Fear"),
                               Slice(percent: 0.08, color: UIColor.lightGray.withAlphaComponent(0.8), status: "Neutral"),
                               Slice(percent: 0.10, color: UIColor.lightGray.withAlphaComponent(0.8), status: "Greed"),
                               Slice(percent: 0.11, color: UIColor.lightGray.withAlphaComponent(0.8), status: "Extreme Greed"),
                               Slice(percent: 0.5, color: UIColor.black, status: " ")]
        
        self.chartView.addSubview(pieChartView)
        pieChartView.animateChart()
    }
    
    
    
}
