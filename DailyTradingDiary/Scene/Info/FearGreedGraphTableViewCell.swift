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
        return label
    }()

    let nowStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 44)
        label.textAlignment = .center
        return label
    }()
    
    let weekAgoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    
    override func configure() {
        [updateTimeLabel, nowValueLabel, nowStatusLabel, weekAgoValueLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        updateTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        
        nowValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(nowStatusLabel.snp.top).offset(-10)
        }
        
        nowStatusLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
        
        weekAgoValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(nowStatusLabel.snp.bottom).offset(14)
        }

    }
    
    func setData(data: FearGreedDTO) {
        let updateDate = changeFormatDate(data: data.updateTime)
        
        self.updateTimeLabel.text = "(UPDATE \(updateDate))"
        self.nowValueLabel.text = "\(data.now.indexValue)"
        self.nowStatusLabel.text = data.now.indexStatus
        self.weekAgoValueLabel.text = "(1주 전: \(data.weekAgo.indexValue), \(data.weekAgo.indexStatus))"
    }
    
    func changeFormatDate(data: String) ->  String {
        let index = data.firstIndex(of: "T") ?? data.endIndex
        let begin = data[..<index]
        return begin.replacingOccurrences(of: "-", with:    ".")
    }
    
    
}
