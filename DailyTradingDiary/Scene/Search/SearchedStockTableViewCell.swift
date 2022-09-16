//
//  SearchedStockTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import UIKit

class SearchedStockTableViewCell: BaseTableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let marketLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    let srtnCdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    let isinCdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    override func configure() {
        [nameLabel, marketLabel, srtnCdLabel, isinCdLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
        }
        
        marketLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        srtnCdLabel.snp.makeConstraints { make in
            make.leading.equalTo(marketLabel.snp.trailing).offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        isinCdLabel.snp.makeConstraints { make in
            make.leading.equalTo(srtnCdLabel.snp.trailing).offset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
    }
    
    func setDataAtCell(arr: [KRXModel], indexPath: IndexPath) {
        let row = arr[indexPath.row]
        self.nameLabel.text = row.itemName
        self.marketLabel.text = row.marketName
        self.srtnCdLabel.text = row.srtnCode
        self.isinCdLabel.text = row.isinCode
    }
    
}

