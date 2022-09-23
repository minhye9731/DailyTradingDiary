//
//  SettingView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/24/22.
//

import UIKit

final class SettingView: BaseView {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.rowHeight = 50
        tableview.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        return tableview
    }()
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
    
    
}
