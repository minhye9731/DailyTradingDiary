//
//  SettingTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/24/22.
//

import UIKit

class SettingTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    override func configure() {
        [nameLabel, subLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        
        subLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
