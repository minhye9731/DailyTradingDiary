//
//  TradingDiaryView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit
import SnapKit


final class TradingDiaryView: BaseView {

    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.backgroundColor = .backgroundColor
        tableview.register(CorpNameTableViewCell.self, forCellReuseIdentifier: CorpNameTableViewCell.reuseIdentifier)
        tableview.register(TradeDateTableViewCell.self, forCellReuseIdentifier: TradeDateTableViewCell.reuseIdentifier)
        tableview.register(BuySellTableViewCell.self, forCellReuseIdentifier: BuySellTableViewCell.reuseIdentifier)
        tableview.register(NumPriceTableViewCell.self, forCellReuseIdentifier: NumPriceTableViewCell.reuseIdentifier)
        tableview.register(TradingMemoTableViewCell.self, forCellReuseIdentifier: TradingMemoTableViewCell.reuseIdentifier)
        return tableview
    }()

    override func configureUI() {
        self.addSubview((tableView))
    }

    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

}
