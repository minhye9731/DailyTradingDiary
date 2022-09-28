//
//  BuySellTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit

class BuySellTableViewCell: BaseTableViewCell {
    
    var segmentTapped : (() -> Void) = {}
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "* 매수 · 매도"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["매수", "매도"])
        view.selectedSegmentIndex = 0
        view.backgroundColor = .pointColor
        view.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        view.selectedSegmentTintColor = .white
        view.addTarget(self, action: #selector(buysellChanged), for: .valueChanged)
        return view
    }()
    
    override func configure() {
        [nameLabel, segmentControl].forEach {
            contentView.addSubview($0)
        }
        giveColorString(label: nameLabel, colorStr: "*", color: .systemRed)
    }
    
    override func setConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.centerY.equalTo(self)
        }
    }
    
    @objc func buysellChanged() {
        print("매수매도 여부 값이 변함 toggle")
        segmentTapped()
    }
    
    
}



