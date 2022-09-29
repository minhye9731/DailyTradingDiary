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
        
        //        let spacing = 16
        
        tagLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(self.tagLabel.snp.bottom).offset(6)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(36)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        isTradingLabel.snp.makeConstraints { make in
            make.leading.equalTo(amountLabel.snp.trailing).offset(12)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(isTradingLabel.snp.trailing).offset(12)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
        }
    }
    
    func setData(arr: [TradingDiaryRealmModel], indexPath: IndexPath) {
        
        let row = arr[indexPath.row]
        
        self.nameLabel.text = row.corpName
        self.amountLabel.text = "\(row.tradingAmount) \(Constants.Word.countStock.rawValue)"
        self.isTradingLabel.text = row.buyAndSell ? Constants.Word.sell.rawValue : Constants.Word.buy.rawValue
        self.priceLabel.text = "(\(Constants.Word.tradingPrice.rawValue) : \(row.tradingPrice) \(Constants.CurrencySign.won.rawValue))"
    }
    
}
