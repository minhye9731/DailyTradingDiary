//
//  HomeTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class TradeTableViewCell: BaseTableViewCell {
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "매매일지"
        label.textColor = .black
        label.backgroundColor = .tradeDiaryTagColor
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let isTradingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override func configure() {
        backgroundColor = .cellBackgroundColor
        [tagLabel, nameLabel, amountLabel, isTradingLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        tagLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(self.tagLabel.snp.bottom).offset(6)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(nameLabel)
        }
        
        isTradingLabel.snp.makeConstraints { make in
            make.leading.equalTo(amountLabel.snp.trailing).offset(15)
            make.centerY.equalTo(nameLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    func setData(arr: [TradingDiaryRealmModel], indexPath: IndexPath) {
        
        let row = arr[indexPath.row]
        
        self.nameLabel.text = row.corpName
        self.amountLabel.text = "\(row.tradingAmount) \(Constants.Word.countStock.rawValue)"
        
        self.isTradingLabel.text = row.buyAndSell ? Constants.Word.sell.rawValue : Constants.Word.buy.rawValue
        self.isTradingLabel.textColor = row.buyAndSell ? .systemBlue : .systemRed
        
        self.priceLabel.text = "(\(Constants.Word.tradingPrice.rawValue) : \(row.tradingPrice) \(Constants.CurrencySign.won.rawValue))"
        
        
    }
    
}
