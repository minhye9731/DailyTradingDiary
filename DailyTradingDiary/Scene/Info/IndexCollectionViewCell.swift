//
//  IndexCollectionViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import UIKit

final class IndexCollectionViewCell: BaseCollectionViewCell {
    
    let itembackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .subBackgroundColor
        view.layer.cornerRadius = Constants.Desgin.cornerRadius
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "비트코인" // 삭제예정
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Constants.CurrencySign.dollar.rawValue) 18,709.19 " // 삭제예정
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "+0.32 (+0.16%)" // (삭제예정)  기호구분, gqp 수치, 증감률 수치
        label.textColor = .red
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    override func configure() {
        
        self.addSubview(itembackgroundView)
        [nameLabel, valueLabel, resultLabel].forEach {
            itembackgroundView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        itembackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.centerY.equalTo(self)
            make.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.top.equalTo(itembackgroundView.snp.top).offset(10)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.top.equalTo(valueLabel.snp.bottom).offset(3)
        }
    }
    
    func setData(arr: [IndexData], indexPath: IndexPath) {

        let row = arr[indexPath.row]
        decideColor(gap: row.gap)

        self.nameLabel.text = row.name
        self.valueLabel.text = row.value
        self.resultLabel.text = "\(row.gap)" + "(\(row.changeRate)%)"
    }
    
    func decideColor(gap: String) {
        
        guard let gapValue = Double(gap) else { return }
        
        if gapValue > 0 {
            self.valueLabel.textColor = .systemRed
        } else if gapValue < 0 {
            self.valueLabel.textColor = .systemBlue
        }
        self.valueLabel.textColor = .mainTextColor
    }
    
    
}

