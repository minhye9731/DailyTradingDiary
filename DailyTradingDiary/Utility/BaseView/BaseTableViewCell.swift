//
//  BaseTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SkeletonView

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.backgroundColor = .subBackgroundColor
    }
    
    func setConstraints() {}
    
    func giveColorString(label: UILabel, colorStr: String, color: UIColor) {
        
        let attributeLabelStr = NSMutableAttributedString(string: label.text!)
        
        attributeLabelStr.addAttribute(.foregroundColor, value: color, range: (label.text! as NSString).range(of: colorStr))
        
        label.attributedText = attributeLabelStr
    }
}
