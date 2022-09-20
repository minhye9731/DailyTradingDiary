//
//  FearGreedGraphTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import UIKit

final class FearGreedGraphTableViewCell: BaseTableViewCell {
    
    let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "ex) 업데이트 2022.09.19 07:27" // 삭제예정
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let chartView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemMint
        return view
    }()
    
    let fearLabel: UILabel = {
        let label = UILabel()
        label.text = "공포 (0)"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let greedLabel: UILabel = {
        let label = UILabel()
        label.text = "탐욕 (100)"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    override func configure() {
        [updateTimeLabel, chartView, fearLabel, greedLabel].forEach {
            contentView.addSubview($0)
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
        
    }
    
}
