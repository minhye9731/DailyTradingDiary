//
//  CorpNameTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class CorpNameTableViewCell: BaseTableViewCell {
    
    var textFieldTapped : (() -> Void) = {}
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "* 종목명"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let corpNameLabel: UILabel = {
        let label = UILabel()
        label.text = "매매한 종목명 검색하기"
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        return label
    }()
    
//    let corpNameTextField: UITextField = {
//        let textfield = UITextField()
//        textfield.placeholder = "(기업명)"
//        textfield.tintColor = .pointColor
//        textfield.textAlignment = .right
//        textfield.keyboardType = .default
//        textfield.autocorrectionType = .no
//        textfield.autocapitalizationType = .none
//        return textfield
//    }()
    
    
    
    override func configure() {
//        [searchBar, nameLabel].forEach {
//            contentView.addSubview($0)
//        }
        
//        [nameLabel, corpNameTextField].forEach {
//            contentView.addSubview($0)
//        }
        
        [nameLabel, corpNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        giveColorString(label: nameLabel, colorStr: "*")
        
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
//        corpNameTextField.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
//            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
//            make.centerY.equalTo(self)
//        }
        
        corpNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(self)
        }
    }
    
//    @objc func textFieldDidChange() {
//        textFieldTapped()
//    }
    
}
