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
//        calendar.backgroundColor = .backgroundColor
        return calendar
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.rowHeight = 70
        tableview.register(TradeTableViewCell.self, forCellReuseIdentifier: TradeTableViewCell.reuseIdentifier)
        return tableview
    }()
    
    let floatingButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = .pointColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    override func configureUI() {
        [calendar, tableView, floatingButton].forEach {
            self.addSubview($0)
        }
        
        let image = UIImage(systemName: Constants.ImageName.plus.rawValue, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .light))
        floatingButton.setImage(image, for: .normal)
        floatingButton.setTitleColor(.backgroundColor, for: .normal)
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(320)
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-28)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-36)
            make.width.height.equalTo(60)
        }
        
    }
    

    
}









