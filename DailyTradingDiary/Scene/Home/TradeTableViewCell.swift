//
//  HomeTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

final class TradeTableViewCell: BaseTableViewCell {
    
    let infoView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .cellBackgroundColor
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
        return view
    }()
    
    let isTradingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let stockStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.spacing = 3
        return stackview
    }()
    
    override func configure() {
        contentView.addSubview(infoView)
        
        [isTradingLabel, stockStackView, totalLabel].forEach {
            infoView.addSubview($0)
        }
        
        [nameLabel, amountLabel].forEach {
            stockStackView.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraints() {
        
        infoView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
        }
        
        isTradingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.leading.equalTo(infoView.snp.leading).offset(12)
        }
        
        stockStackView.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.leading.equalTo(isTradingLabel.snp.trailing).offset(12)
            make.width.equalTo(130)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView.snp.centerY)
            make.trailing.equalTo(infoView.snp.trailing).offset(-15)
            make.width.equalTo(infoView.snp.width).multipliedBy(0.55)
        }
        
    }
    
    func setData(arr: [TradingDiaryRealmModel], indexPath: IndexPath) {
        
        let row = arr[indexPath.row]
        let price = thousandSeparatorCommas(value: row.tradingAmount * row.tradingPrice)
        print(price)
        
        self.isTradingLabel.text = row.buyAndSell ? Constants.Word.sell.rawValue : Constants.Word.buy.rawValue
        self.isTradingLabel.textColor = row.buyAndSell ? .systemBlue : .systemRed
        
        self.nameLabel.text = row.corpName
        self.amountLabel.text = "\(row.tradingAmount) \(Constants.Word.countStock.rawValue)"
        
        self.totalLabel.text = "\(price) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func thousandSeparatorCommas(value: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(for: value) ?? "0"
    }
    
    
    
}
