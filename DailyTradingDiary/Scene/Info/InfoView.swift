//
//  InfoView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import Foundation
import SnapKit
import UIKit

final class InfoView: BaseView {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.register(IndexTableViewCell.self, forCellReuseIdentifier: IndexTableViewCell.reuseIdentifier)
        tableview.register(FearGreedGraphTableViewCell.self, forCellReuseIdentifier: FearGreedGraphTableViewCell.reuseIdentifier)
        tableview.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        tableview.register(InfoTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: InfoTableViewHeaderView.reuseIdentifier)
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
