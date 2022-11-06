//
//  AssetListTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 11/6/22.
//

import UIKit

final class AssetListTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    let colorView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let stockStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.spacing = 3
        return stackview
    }()
    
    // MARK: - functions
    override func configure() {
        [colorView, stockStackView, totalLabel].forEach {
            contentView.addSubview($0)
        }
        
        [nameLabel, amountLabel].forEach {
            stockStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        colorView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
            make.width.equalTo(8)
        }
        
        stockStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(colorView.snp.trailing).offset(12)
            make.width.equalTo(120)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.55)
        }
    }
    
    func setData(data: [newVersionSlice], indexPath: IndexPath) {
        
        let row = data[indexPath.row]
        let percentage = round(row.percent * 1000) / 10
        
        colorView.backgroundColor = row.color
        nameLabel.text = row.name
        amountLabel.text = "\(percentage)%"
        totalLabel.text = "\(row.totalRemain)₩"
    }
    
}
