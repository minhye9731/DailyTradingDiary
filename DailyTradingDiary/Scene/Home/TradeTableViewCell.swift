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
        label.font = .boldSystemFont(ofSize: 10)
        label.backgroundColor = .systemGreen // 상세 디자인 변경 예정
        label.textAlignment = .center
        label.layer.cornerRadius = Constants.Desgin.cornerRadius
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
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let isTradingLabel: UILabel = {
        let label = UILabel()
        //        label.textColor = .subTextColor 매수/매도 여부에 따라서 색상구분(빨/파)
        // 매수/매도 여부에 따라서 문구구분(매수/매도)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray5 // 변경가능
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override func configure() {
        backgroundColor = .cellBackgroundColor
        // nameLabel, amountLabel, isTradingLabel, priceLabel
        [tagLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        //        self.dateLabel.setContentHuggingPriority( .defaultHigh, for: .horizontal)
        
        //        let spacing = 16
        
        tagLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(30)
            make.height.equalTo(10)
        }
        
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
//            make.top.equalTo(self.tagLabel.snp.bottom).offset(6)
//        }
//
//        amountLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
//        }
//
//        isTradingLabel.snp.makeConstraints { make in
//            make.leading.equalTo(amountLabel.snp.trailing).offset(12)
//            make.top.equalTo(self.tagLabel.snp.bottom).offset(30)
//        }
//
//        priceLabel.snp.makeConstraints { make in
//            make.leading.equalTo(isTradingLabel.snp.trailing).offset(12)
////            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-12)
//            make.top.equalTo(self.tagLabel.snp.bottom).offset(30)
//        }
        

        //    func setDataAtCell(arr: [UserMemo], indexPath: IndexPath) {
        //        let row = arr[indexPath.row]
        //        self.titleLabel.text = row.memoTitle
        //        self.dateLabel.text = "\(getProperDateForm(memotime: row.memoDate))"
        //        self.contentLabel.text = row.memoContent
        //    }
        
    }
    
}
