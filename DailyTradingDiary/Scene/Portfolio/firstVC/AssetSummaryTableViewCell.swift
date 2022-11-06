//
//  AssetSummaryTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 11/6/22.
//

import UIKit

final class AssetSummaryTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    // 투자원금
//    let investmentLabel: UILabel = {
//        let label = UILabel()
//        label.text = "투자원금"
//        label.textColor = .mainTextColor
//        label.font = .boldSystemFont(ofSize: 16)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let investmentValueLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .mainTextColor
//        label.font = .systemFont(ofSize: 16)
//        label.textAlignment = .right
//        return label
//    }()
//
//    // 평가손익
//    let gainLossLabel: UILabel = {
//        let label = UILabel()
//        label.text = "평가손익"
//        label.textColor = .mainTextColor
//        label.font = .boldSystemFont(ofSize: 16)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let gainLossValueLabel: UILabel = {
//        let label = UILabel()
//        label.text = "+ 22,222 \(Constants.CurrencySign.won.rawValue)" // 뷰컨에서 전달예정
//        label.textColor = .systemRed // 뷰컨에서 로직걸기
//        label.font = .systemFont(ofSize: 16)
//        label.textAlignment = .right
//        return label
//    }()
//
//    // 수익률
//    let earningsRateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "수익률"
//        label.textColor = .mainTextColor
//        label.font = .boldSystemFont(ofSize: 16)
//        label.textAlignment = .left
//        return label
//    }()
//
//    let earningsRateValueLabel: UILabel = {
//        let label = UILabel()
//        label.text = "+ 28.57 %" // 뷰컨에서 전달예정
//        label.textColor = .systemRed // 뷰컨에서 로직걸기
//        label.font = .systemFont(ofSize: 16)
//        label.textAlignment = .right
//        return label
//    }()

    
    // MARK: - functions
    override func configure() {
        contentView.addSubview(resultLabel)
    }
    
    override func setConstraints() {
        resultLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func getData(total: String) {
        resultLabel.text = "\(total) \(Constants.CurrencySign.won.rawValue)"
    }

}
