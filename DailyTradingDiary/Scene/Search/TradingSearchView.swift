//
//  TradingSearchView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/30/22.
//

import UIKit


final class TradingSearchView: BaseView {
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        tableview.register(SearchedStockTableViewCell.self, forCellReuseIdentifier: SearchedStockTableViewCell.reuseIdentifier)
        tableview.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        tableview.rowHeight = 50
        return tableview
    }()
    
    let emptyView: EmptyView = {
       let view = EmptyView()
        return view
    }()
    
    override func configureUI() {
        [tableView, emptyView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
}
