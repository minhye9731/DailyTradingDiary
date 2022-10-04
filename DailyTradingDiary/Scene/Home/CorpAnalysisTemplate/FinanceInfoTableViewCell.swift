//
//  FinanceInfoTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit

final class FinanceInfoTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let threeYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-" // test
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    let twoYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-" // test
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    let oneYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-" // test
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    
    override func configure() {
        [nameLabel, threeYrsBfValueLabel, twoYrsBfValueLabel, oneYrsBfValueLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        threeYrsBfValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(twoYrsBfValueLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        twoYrsBfValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(oneYrsBfValueLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        oneYrsBfValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
    }
    
    // MARK: - 주요 재무정보 데이터 적용
    func setFinStatementData(data: [DartFinInfoDTO], indexPath: IndexPath) {
        let row = data[indexPath.row]
        self.threeYrsBfValueLabel.text = makeHundMil(rawValue: row.amount_3yr_bf)
        self.twoYrsBfValueLabel.text = makeHundMil(rawValue: row.amount_2yr_bf)
        self.oneYrsBfValueLabel.text = makeHundMil(rawValue: row.amount_1yr_bf)
    }
    
    // MARK: - 배당금 데이터 적용
    func setDividendData(data: [DartDividendDTO], indexPath: IndexPath) {
        
        let row = data[indexPath.row]
        self.threeYrsBfValueLabel.text = row.amount_3yr_bf
        self.twoYrsBfValueLabel.text = row.amount_2yr_bf
        self.oneYrsBfValueLabel.text = row.amount_1yr_bf

    }
    
    // 단위별 상세처리 필요
    func makeHundMil(rawValue: String) -> String {
        
        guard let data = Double(rawValue.dropLast(5)) else { return rawValue }
        let hmValue = data / 100.0
        let roundedValue = round(hmValue * 10.0) / 10.0
        
        return String(roundedValue) + " 억"
    }
    
    
    
}
