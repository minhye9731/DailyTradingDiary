//
//  NumPriceTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class NumPriceTableViewCell: BaseTableViewCell {
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "수량"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "00"
        textfield.textAlignment = .center
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let priceTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0000"
        textfield.textAlignment = .center
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    let amountStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.spacing = 8
        return stackview
    }()
    
    let priceStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.spacing = 8
        return stackview
    }()
    
    
    override func configure() {
        [amountStackView, priceStackView].forEach {
            contentView.addSubview($0)
        }
        
        [amountLabel, amountTextField].forEach {
            amountStackView.addArrangedSubview($0)
        }
        
        [priceLabel, priceTextField].forEach {
            priceStackView.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraints() {
        
        amountLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
//        priceTextField.snp.makeConstraints { make in
//            make.width.equalTo(24)
//        }
        
        amountStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.45)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.leading.equalTo(amountStackView.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(self)
        }
    }
    
}
