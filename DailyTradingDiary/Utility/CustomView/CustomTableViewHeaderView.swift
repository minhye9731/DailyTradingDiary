//
//  CustomTableViewHeaderView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import UIKit
import SnapKit

final class CustomTableViewHeaderView: UITableViewHeaderFooterView {
    
    var sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    var grayline: UIView = {
        let view = UIView()
        view.backgroundColor = .subTextColor
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [sectionTitleLabel, grayline].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self)
        }
        
        grayline.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    func giveColorString(label: UILabel, colorStr: String) {
        
        let attributeLabelStr = NSMutableAttributedString(string: label.text!)
        
        attributeLabelStr.addAttribute(.foregroundColor, value: UIColor.pointColor, range: (label.text! as NSString).range(of: colorStr))
        
        label.attributedText = attributeLabelStr
    }
    
    
}
