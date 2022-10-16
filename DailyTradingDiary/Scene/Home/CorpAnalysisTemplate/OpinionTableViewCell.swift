//
//  OpinionTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit

final class OpinionTableViewCell: BaseTableViewCell {
    
    let opinionTextView: UITextView = {
        let textview = UITextView()
        textview.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0)
        textview.font = .systemFont(ofSize: 16)
        textview.tintColor = .pointColor
        textview.backgroundColor = .clear
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.subTextColor.cgColor
        textview.layer.cornerRadius = 10
        
        textview.autocorrectionType = .no
        textview.autocapitalizationType = .none
        return textview
    }()
    
//    let letterCountLabel: UILabel = {
//        let label = UILabel()
//        label.text = "0/300"
//        label.font = .systemFont(ofSize: 16)
//        label.textColor = .subTextColor
//        label.textAlignment = .right
//        return label
//    }()
    
    // 매수희망가
    let eBuyPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "매수희망가"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemRed
        return label
    }()
    let eBuyTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0"
        textfield.tintColor = .pointColor
        textfield.font = .systemFont(ofSize: 20)
        textfield.textAlignment = .right
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    // 매수희망일
    let eBuyDateLabel: UILabel = {
        let label = UILabel()
        label.text = "매수희망일"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemRed
        return label
    }()
    lazy var eBuyDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .subBackgroundColor
        datePicker.tintColor = .pointColor
        return datePicker
    }()
    
    //매도희망가
    let eSellPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "매도희망가"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    let eSellTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0"
        textfield.tintColor = .pointColor
        textfield.font = .systemFont(ofSize: 20)
        textfield.textAlignment = .right
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    //매도희망일
    let eSellDateLabel: UILabel = {
        let label = UILabel()
        label.text = "매도희망일"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    lazy var eSellDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .subBackgroundColor
        datePicker.tintColor = .pointColor
        return datePicker
    }()
    
    
    override func configure() {
        [opinionTextView, eBuyPriceLabel, eBuyDateLabel, eSellPriceLabel, eSellDateLabel, eBuyTextField, eSellTextField, eBuyDatePicker, eSellDatePicker].forEach {
            contentView.addSubview($0)
        }

    }
    
    override func setConstraints() {
        
        opinionTextView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(200)
        }
        
//        letterCountLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(opinionTextView.snp.trailing).offset(-4)
//            make.bottom.equalTo(opinionTextView.snp.bottom).offset(-4)
//        }
        
        // 매수희망가
        eBuyPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(opinionTextView.snp.bottom).offset(15)
        }
        eBuyTextField.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(eBuyPriceLabel.snp.centerY)
            make.width.equalTo(160)
        }

        // 매수희망일
        eBuyDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(eBuyPriceLabel.snp.bottom).offset(12)
        }
        eBuyDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(eBuyDateLabel.snp.centerY)
        }

        // 매도희망가
        eSellPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(eBuyDateLabel.snp.bottom).offset(18)
            make.width.equalTo(160)
        }
        eSellTextField.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(eSellPriceLabel.snp.centerY)
        }

        // 매도희망일
        eSellDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(eSellPriceLabel.snp.bottom).offset(12)
        }
        eSellDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(eSellDateLabel.snp.centerY)
        }
        
    }
}
