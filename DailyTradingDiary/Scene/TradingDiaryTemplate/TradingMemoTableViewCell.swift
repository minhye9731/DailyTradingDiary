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
        textview.text = "매수·매도의 근거와 전략을 적어주세요 :)"
        textview.textColor = .subTextColor
        textview.backgroundColor = .clear
        return textview
    }()
    
    
    override func configure() {
        contentView.addSubview(memoTextView)
    }

    override func setConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            
        }
    }
    
}


