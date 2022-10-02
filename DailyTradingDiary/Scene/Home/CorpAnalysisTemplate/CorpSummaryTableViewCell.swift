//
//  CorpSummaryTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit

final class CorpSummaryTableViewCell: BaseTableViewCell {
    
    let updateDateLabel: UILabel = {
        let label = UILabel()
        label.text = "(UPDATE ----.--.--)"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .subTextColor
        return label
    }()
    
    let corpIdtLabel: UILabel = {
        let label = UILabel()
        label.text = " - ( - - )"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .mainTextColor
        return label
    }()
    
    let nowPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "시가 : -"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let highPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "고가 : -"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .subTextColor
        return label
    }()
    
    let lowPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "저가 : -"
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
        label.text = " - "
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
        label.text = " - "
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainTextColor
        return label
    }()
    
    override func configure() {
        [updateDateLabel, corpIdtLabel, nowPriceLabel, highPriceLabel, lowPriceLabel, trdQutLabel, trdQutValueLabel, mrkTotAmtLabel, mrkTotAmtValueLabel].forEach {
            contentView.addSubview($0)
        }
    
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

    func setData(data: [StockSummaryDTO], indexPath: IndexPath) {
        
        let row = data[indexPath.row]
        
        print("데이터 담기 실행~")
        self.updateDateLabel.text = "(UPDATE \(row.updateDate))"
        self.corpIdtLabel.text = "\(row.corpName) (\(row.marketName) \(row.srtnCode))"
        self.nowPriceLabel.text = "시가 : \(row.nowPrice)"
        self.highPriceLabel.text = "고가 : \(row.highPrice)"
        self.lowPriceLabel.text = "저가 : \(row.lowPrice)"
        self.trdQutValueLabel.text = "\(row.tradingQnt)"
        self.mrkTotAmtValueLabel.text = "\(row.totAmt)"

        giveColorString(label: nowPriceLabel, colorStr: row.nowPrice, color: .systemBlue)
        giveColorString(label: highPriceLabel, colorStr: row.highPrice, color: .systemRed)
        giveColorString(label: lowPriceLabel, colorStr: row.lowPrice, color: .systemBlue)
        
        print("mrkTotAmtValueLabel: \(row.totAmt)")
    }
    
}
