//
//  CorpAnalysis.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import Foundation
import UIKit

final class CorpAnalysis: BaseView {
    
    // 상단 기업검색뷰
    let selectCorpView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    let showselectCorpView: UIView = {
        let view = UIView()
         view.backgroundColor = .subBackgroundColor
        view.layer.cornerRadius = 10
         return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "* 기업명"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .mainTextColor
        return label
    }()
    
    let nameResultLabel: UILabel = {
        let label = UILabel()
        label.text = "(기업명)"
        label.font = .systemFont(ofSize: 17)
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        return label
    }()
    
    // 테이블뷰
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.backgroundColor = .backgroundColor
        tableview.register(CorpSummaryTableViewCell.self, forCellReuseIdentifier: CorpSummaryTableViewCell.reuseIdentifier)
        tableview.register(TitleNameTableViewCell.self, forCellReuseIdentifier: TitleNameTableViewCell.reuseIdentifier)
        tableview.register(FinanceInfoTableViewCell.self, forCellReuseIdentifier: FinanceInfoTableViewCell.reuseIdentifier)
        tableview.register(OpinionTableViewCell.self, forCellReuseIdentifier: OpinionTableViewCell.reuseIdentifier)
        
        tableview.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        return tableview
    }()
    
    override func configureUI() {
        
        
        
        [selectCorpView, showselectCorpView, nameLabel, nameResultLabel, tableView].forEach {
            self.addSubview($0)
        }
        
        giveColotString(label: nameLabel, colorStr: "*", color: .systemRed)
    }
    
    override func setConstraints() {
        // 상단 기업 검색/표기란
        selectCorpView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        
        showselectCorpView.snp.makeConstraints { make in
            make.top.equalTo(selectCorpView.snp.top).offset(12)
            make.leading.equalTo(selectCorpView.snp.leading).offset(16)
            make.trailing.equalTo(selectCorpView.snp.trailing).offset(-12)
            make.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(showselectCorpView.snp.leading).offset(16)
            make.centerY.equalTo(showselectCorpView)
        }
        
        nameResultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(showselectCorpView.snp.trailing).offset(-45)
            make.centerY.equalTo(showselectCorpView)
        }
        
        
        // 하단 tableview
        tableView.snp.makeConstraints { make in
            make.top.equalTo(selectCorpView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
}
