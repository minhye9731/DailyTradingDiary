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
    
//    let contentLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 13)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let contentLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 13)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let contentLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 13)
//        label.textAlignment = .left
//        return label
//    }()
//
//    override func configure() {
//        backgroundColor = .cellBackgroundColor
//
//        [titleLabel, dateLabel, contentLabel].forEach {
//            contentView.addSubview($0)
//        }
//    }
//
//    override func setConstraints() {
//
//        self.dateLabel.setContentHuggingPriority( .defaultHigh, for: .horizontal)
//
//        let spacing = 16
//
//        titleLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
//            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
//        }
//
//        dateLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
//            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
//            make.trailing.equalTo(self.contentLabel.snp.leading).offset(-8)
//        }
//
//        contentLabel.snp.makeConstraints { make in
//            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
//            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
//        }
//
//
//    }
//
//    func getProperDateForm(memotime: Date) -> String {
//
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//
//        if memotime.isInToday {
//            formatter.dateFormat = "a HH:mm"
//        } else if memotime.isInThisWeek {
//            formatter.dateFormat = "EEEE"
//        } else {
//            formatter.dateFormat = "yyyy. MM. dd a HH:mm"
//        }
//
//        return formatter.string(from: memotime)
//    }
//
//    func setDataAtCell(arr: [UserMemo], indexPath: IndexPath) {
//        let row = arr[indexPath.row]
//        self.titleLabel.text = row.memoTitle
//        self.dateLabel.text = "\(getProperDateForm(memotime: row.memoDate))"
//        self.contentLabel.text = row.memoContent
//    }
//
}

