//
//  TitleNameTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit

final class TitleNameTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "항목명"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .subTextColor
        label.textAlignment = .left
        return label
    }()
    
    let threeYrsBfLabel: UILabel = {
        let label = UILabel()
        label.text = "3년 전"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .subTextColor
        label.textAlignment = .right
        return label
    }()
    
    let twoYrsBfLabel: UILabel = {
        let label = UILabel()
        label.text = "2년 전"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .subTextColor
        label.textAlignment = .right
        return label
    }()
    
    let oneYrsBfLabel: UILabel = {
        let label = UILabel()
        label.text = "1년 전"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .subTextColor
        label.textAlignment = .right
        return label
    }()
    
    override func configure() {
        
        [nameLabel, threeYrsBfLabel, twoYrsBfLabel, oneYrsBfLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        threeYrsBfLabel.snp.makeConstraints { make in
            make.trailing.equalTo(twoYrsBfLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        twoYrsBfLabel.snp.makeConstraints { make in
            make.trailing.equalTo(oneYrsBfLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        oneYrsBfLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
    }
    
}

