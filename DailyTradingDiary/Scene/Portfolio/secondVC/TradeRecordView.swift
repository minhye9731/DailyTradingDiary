//
//  TradeRecordView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit

final class TradeRecordView: BaseView {
    
    // MARK: - searchView
    let searchView: UIView = {
       let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    // 전체기간
    lazy var fromDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .subBackgroundColor
        datePicker.tintColor = .pointColor
        return datePicker
    }()
    
    let tildeLabel: UILabel = {
        let label = UILabel()
        label.text = "~"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    lazy var toDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .subBackgroundColor
        datePicker.tintColor = .pointColor
        return datePicker
    }()
    
    // 전체&매수&매도
    let seperateLabel: UILabel = {
        let label = UILabel()
        label.text = "매매 구분"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["전체", "매수", "매도"])
        view.selectedSegmentIndex = 0
        view.backgroundColor = .pointColor
        view.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        view.selectedSegmentTintColor = .white
        return view
    }()
    
    // 매수총액
    let totalBuyLabel: UILabel = {
        let label = UILabel()
        label.text = "매수 총액"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let totalBuyValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 매도총액
    let totalSellLabel: UILabel = {
        let label = UILabel()
        label.text = "매도 총액"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let totalSellValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 실현손익
    let profitLossLabel: UILabel = {
        let label = UILabel()
        label.text = "실현 손익"
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let profitLossValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = .backgroundColor
        tableview.rowHeight = 70
        tableview.register(TradeTableViewCell.self, forCellReuseIdentifier: TradeTableViewCell.reuseIdentifier)
        tableview.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        return tableview
    }()
    
    let emptyView: EmptyView = {
       let view = EmptyView()
        view.setDataAtEmptyView(image: "accountingBook.png", main: "조회하신 조건에 해당하는 매매일지가 없어요.", sub: "홈화면의 + 버튼으로 매매일지를 작성해\n조건별 거래내역을 확인해보세요.")
        return view
    }()
    
    override func configureUI() {
        [searchView, tableView, emptyView].forEach {
            self.addSubview($0)
        }
        
        [fromDatePicker, tildeLabel, toDatePicker, seperateLabel, segmentControl, totalBuyLabel, totalBuyValueLabel, totalSellLabel, totalSellValueLabel, profitLossLabel, profitLossValueLabel, grayline].forEach {
            searchView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        
        let spacing = 16
        
        // MARK: - searchview
        searchView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(210)
        }
        
        // 기간선택
        tildeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.searchView)
            make.top.equalTo(searchView.snp.top).offset(20)
        }
        fromDatePicker.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.top).offset(20)
            make.trailing.equalTo(tildeLabel.snp.leading).offset(-50)
        }
        toDatePicker.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.top).offset(20)
            make.leading.equalTo(tildeLabel.snp.trailing).offset(50)
        }
        
        // 구분선택
        seperateLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.leading).offset(14)
            make.top.equalTo(fromDatePicker.snp.bottom).offset(20)
        }
        segmentControl.snp.makeConstraints { make in
            make.trailing.equalTo(searchView.snp.trailing).inset(14)
            make.centerY.equalTo(seperateLabel.snp.centerY)
        }
        
        // 매수총액
        totalBuyLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.leading).offset(14)
            make.top.equalTo(seperateLabel.snp.bottom).offset(spacing)
        }
        totalBuyValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(searchView.snp.trailing).inset(14)
            make.centerY.equalTo(totalBuyLabel.snp.centerY)
        }
        
        // 매도총액
        totalSellLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.leading).offset(14)
            make.top.equalTo(totalBuyLabel.snp.bottom).offset(spacing)
        }
        totalSellValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(searchView.snp.trailing).inset(14)
            make.centerY.equalTo(totalSellLabel.snp.centerY)
        }
        
        // 실현손익
        profitLossLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchView.snp.leading).offset(14)
            make.top.equalTo(totalSellLabel.snp.bottom).offset(spacing)
        }
        profitLossValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(searchView.snp.trailing).inset(14)
            make.centerY.equalTo(profitLossLabel.snp.centerY)
        }
        
        grayline.snp.makeConstraints { make in
            make.bottom.equalTo(searchView.snp.bottom)
            make.leading.trailing.equalTo(self.searchView).inset(14)
            make.height.equalTo(1)
        }
        
        // MARK: - tableview
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(searchView.snp.bottom)
        }
        
        //emptyView
        emptyView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(searchView.snp.bottom)
        }
        
    }
    
    
    
}
