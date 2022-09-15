//
//  AnalysisTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class AnalysisTableViewCell: BaseTableViewCell {
    
//    let tagLabel: UILabel = {
//        let label = UILabel()
//        label.text = "기업분석"
//        label.textColor = .black
//        label.font = .boldSystemFont(ofSize: 10)
//        label.backgroundColor = .systemBlue // 상세 디자인 변경 예정
//        label.textAlignment = .center
//        label.layer.cornerRadius = Constants.Desgin.cornerRadius
//        return label
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .mainTextColor
//        label.font = .boldSystemFont(ofSize: 24)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let buyExpectPriceNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "매수희망가 :"
//        label.textColor = .systemRed
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let buyExpectPriceLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let buyExpectDateNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "매수희망일 :"
//        label.textColor = .systemRed
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let buyExpectDateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let grayLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .mainTextColor
//        return view
//    }()
//
//    let sellExpectPriceNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "매도희망가 :"
//        label.textColor = .systemBlue
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let sellExpectPriceLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let sellExpectDateNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "매도희망일 :"
//        label.textColor = .systemBlue
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let sellExpectDateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .subTextColor
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .left
//        return label
//    }()
//
//    // stackview
//    let buyPriceStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 8
//        return stackview
//    }()
//
//    let buyDateStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 8
//        return stackview
//    }()
//
//    let buyStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .vertical
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 20
//        return stackview
//    }()
//
//    let sellPriceStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 8
//        return stackview
//    }()
//
//    let sellDateStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 8
//        return stackview
//    }()
//
//    let sellStackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .vertical
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 20
//        return stackview
//    }()
//    //
//    let StackView: UIStackView = {
//       let stackview = UIStackView()
//        stackview.axis = .horizontal
//        stackview.alignment = .fill
//        stackview.distribution = .equalSpacing
//        stackview.spacing = 8
//        return stackview
//    }()
//
//
    override func configure() {
//        backgroundColor = .cellBackgroundColor
//
//        [tagLabel, nameLabel, StackView].forEach {
//            contentView.addSubview($0)
//        }
//
//        [buyStackView, grayLineView, sellStackView].forEach {
//            StackView.addArrangedSubview($0)
//        }
//
//        [buyPriceStackView, buyDateStackView].forEach {
//            buyStackView.addArrangedSubview($0)
//        }
//
//        [sellPriceStackView, sellDateStackView].forEach {
//            sellStackView.addArrangedSubview($0)
//        }
//
//        [buyExpectPriceNameLabel, buyExpectPriceLabel].forEach {
//            buyPriceStackView.addArrangedSubview($0)
//        }
//
//        [buyExpectDateNameLabel, buyExpectDateLabel].forEach {
//            buyDateStackView.addArrangedSubview($0)
//        }
//
//        [sellExpectPriceNameLabel, sellExpectPriceLabel].forEach {
//            sellPriceStackView.addArrangedSubview($0)
//        }
//
//        [sellExpectDateNameLabel, sellExpectDateLabel].forEach {
//            sellDateStackView.addArrangedSubview($0)
//        }
    }
//
    override func setConstraints() {
//
////        self.dateLabel.setContentHuggingPriority( .defaultHigh, for: .horizontal)
//
////        let spacing = 16
//
//        tagLabel.snp.makeConstraints { make in
//            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(8)
//            make.width.equalTo(30)
//            make.height.equalTo(10)
//        }
//
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
//            make.top.equalTo(self.tagLabel.snp.bottom).offset(6)
//        }
//
//        StackView.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel.snp.trailing).offset(16)
//            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
//            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
//        }
//
//        grayLineView.snp.makeConstraints { make in
//            make.width.equalTo(1)
//            make.height.equalTo(44)
//        }
    }
//
//

}
