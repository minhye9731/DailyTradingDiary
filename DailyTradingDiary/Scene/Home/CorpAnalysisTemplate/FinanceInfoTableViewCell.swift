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
        label.text = "매출액" // test
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let threeYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2,304,009" // test
        label.font = .systemFont(ofSize: 16)
        label.textColor = .mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    let twoYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2,368,070" // test
        label.font = .systemFont(ofSize: 16)
        label.textColor = .mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    let oneYrsBfValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2,796,048" // test
        label.font = .systemFont(ofSize: 16)
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
    
    // 주요 재무정보 데이터
    
    
    
    
    // 배당금 데이터
    func setDividendData(data: DartDividendModel, indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            threeYrsBfValueLabel.text = data.dps_3yr_bf
            twoYrsBfValueLabel.text = data.dps_2yr_bf
            oneYrsBfValueLabel.text = data.dps_1yr_bf
        case 1:
            threeYrsBfValueLabel.text = data.dividend_payout_ratio_3yr_bf
            twoYrsBfValueLabel.text = data.dividend_payout_ratio_2yr_bf
            oneYrsBfValueLabel.text = data.dividend_payout_ratio_1yr_bf
        default: break
        }
        
        
        
    }
    
    
    
    
    
}
