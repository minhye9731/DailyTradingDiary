//
//  CorpSummaryTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit

class CorpSummaryTableViewCell: BaseTableViewCell {
    
    let updateDateLabel: UILabel = {
        let label = UILabel()
        label.text = "(UPDATE 2022.09.27)" // test
        label.font = .systemFont(ofSize: 12)
        label.textColor = .subTextColor
        return label
    }()
    
    let corpIdtLabel: UILabel = {
        let label = UILabel()
        label.text = "삼성전자(주) (KOSPI 005930)"  // test
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .mainTextColor
        return label
    }()
    
    let nowPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "시가 : 53,900"  // test (파란색)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let highPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "고가 : 54,400"  // test (빨간색)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let lowPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "저가 : 52,500"  // test (파란색)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let trdQutLabel: UILabel = {
        let label = UILabel()
        label.text = "거래량"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let trdQutValueLabel: UILabel = {
        let label = UILabel()
        label.text = "19,656,807" // test
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainTextColor
        return label
    }()

    
    let mrkTotAmtLabel: UILabel = {
        let label = UILabel()
        label.text = "시가총액"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let mrkTotAmtValueLabel: UILabel = {
        let label = UILabel()
        label.text = "323,562,214,210,000" // test
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainTextColor
        return label
    }()
    
    override func configure() {
        [updateDateLabel, corpIdtLabel, nowPriceLabel, highPriceLabel, lowPriceLabel, trdQutLabel, trdQutValueLabel, mrkTotAmtLabel, mrkTotAmtValueLabel].forEach {
            contentView.addSubview($0)
        }
        
        giveColorString(label: nowPriceLabel, colorStr: "53,900", color: .systemBlue) // 이 함수 위치옮기기
        giveColorString(label: highPriceLabel, colorStr: "54,400", color: .systemRed) // 이 함수 위치옮기기
        giveColorString(label: lowPriceLabel, colorStr: "52,500", color: .systemBlue) // 이 함수 위치옮기기
    }
    
    override func setConstraints() {
        
        let spacing = 15
        
        updateDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        
        corpIdtLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.top.equalTo(updateDateLabel.snp.bottom).offset(14)
        }
        
        // 시가, 고가, 저가
        nowPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(corpIdtLabel.snp.bottom).offset(14)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
        }
        
        highPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(corpIdtLabel.snp.bottom).offset(14)
            make.centerX.equalTo(self)
        }
        
        lowPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(corpIdtLabel.snp.bottom).offset(14)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        
        // 거래량, 대금
        trdQutLabel.snp.makeConstraints { make in
            make.top.equalTo(nowPriceLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
        }
        
        trdQutValueLabel.snp.makeConstraints { make in
            make.top.equalTo(nowPriceLabel.snp.bottom).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        
        mrkTotAmtLabel.snp.makeConstraints { make in
            make.top.equalTo(trdQutLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
        }

        mrkTotAmtValueLabel.snp.makeConstraints { make in
            make.top.equalTo(trdQutValueLabel.snp.bottom).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        
    }

    
}
