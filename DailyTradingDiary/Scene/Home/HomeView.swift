//
//  HomeView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import FSCalendar


final class HomeView: BaseView {
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        return calendar
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.rowHeight = 60
        tableview.register(TradeTableViewCell.self, forCellReuseIdentifier: TradeTableViewCell.reuseIdentifier)
//        tableview.register(memoTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: memoTableViewHeaderView.headerViewID)
        tableview.sectionHeaderHeight = 70
        return tableview
    }()
    
    override func configureUI() {
        [calendar, tableView].forEach {
            self.addSubview($0)
        }
        
//        self.addSubview(calendar)
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(320)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    

    
}









