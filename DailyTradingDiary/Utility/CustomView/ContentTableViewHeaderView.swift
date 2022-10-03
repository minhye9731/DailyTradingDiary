//
//  ContentTableViewHeaderView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/3/22.
//

import UIKit
import SnapKit

final class ContentTableViewHeaderView: UITableViewHeaderFooterView {
    
    var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "항목명"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    var threeBFLabel: UILabel = {
        let label = UILabel()
        label.text = "3년 전"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    var twoBFLabel: UILabel = {
        let label = UILabel()
        label.text = "2년 전"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    var oneBFLabel: UILabel = {
        let label = UILabel()
        label.text = "1년 전"
        label.textColor = .subTextColor
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [sectionNameLabel, threeBFLabel, twoBFLabel, oneBFLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        sectionNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.centerY.equalTo(self)
        }
        
        oneBFLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        twoBFLabel.snp.makeConstraints { make in
            make.trailing.equalTo(oneBFLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
        
        threeBFLabel.snp.makeConstraints { make in
            make.trailing.equalTo(twoBFLabel.snp.leading)
            make.centerY.equalTo(self)
            make.width.equalTo(90)
        }
    }
    
    
    
}
