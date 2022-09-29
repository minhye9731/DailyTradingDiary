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
        view.setDataAtEmptyView(image: "accountingBook.png", main: "조회하신 조건에 해당하는 기업정보가 없어요.", sub: "관심기업으로 등록할 기업의 한글명이나 종목코드를 검색해보세요.")
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
