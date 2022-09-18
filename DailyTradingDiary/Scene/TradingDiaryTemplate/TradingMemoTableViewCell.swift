//
//  TradingMemoTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class TradingMemoTableViewCell: BaseTableViewCell {
    
    let memoTextView: UITextView = {
        let textview = UITextView()
        textview.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textview.font = .systemFont(ofSize: 16)
        
        textview.tintColor = .pointColor
        textview.backgroundColor = .clear
        textview.autocorrectionType = .no
        textview.autocapitalizationType = .none
        return textview
    }()
    
    // tableview insetgrouped라 어차피 지금 안보임..추후 Ui 업데이트할때 넣자.
//    let letterNumLabel: UILabel = {
//        let label = UILabel()
//        label.text = "0/300"
//        label.font = .systemFont(ofSize: 16)
//        label.textColor = .subTextColor
//        label.textAlignment = .right
//        return label
//    }()
    
    override func configure() {
        [memoTextView].forEach {
            contentView.addSubview($0)
        }
    }

    override func setConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
        
//        letterNumLabel.snp.makeConstraints { make in
//            make.top.equalTo(memoTextView.snp.bottom).offset(6)
//            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
//        }
    }
    
}


