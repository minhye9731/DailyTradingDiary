//
//  TradeRecordViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import RealmSwift

class TradeRecordViewController: BaseViewController {
    
    let mainView = TradeRecordView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TradingDiaryRepository.standard.fetchRealm()
        
        buySellChangedResult()
        filteringQualificatinos()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteringQualificatinos()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buySellChangedResult()
        filteringQualificatinos()
        self.mainView.tableView.reloadData()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.fromDatePicker.addTarget(self, action: #selector(onDidChangeFromDate(sender:)), for: .valueChanged)
        mainView.toDatePicker.addTarget(self, action: #selector(onDidChangeToDate(sender:)), for: .valueChanged)
        mainView.segmentControl.addTarget(self, action: #selector(buysellChanged), for: .valueChanged)
    }
    
}

// MARK: - tableview 설정
extension TradeRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TradingDiaryRepository.standard.tasks.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        customHeaderView.sectionTitleLabel.text = "조회내역"
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }
        
        tradeCell.setData(arr: Array(TradingDiaryRepository.standard.tasks), indexPath: indexPath)
        
        return tradeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tradeDiaryVC = TradingDiaryViewController()
        let row = Array(TradingDiaryRepository.standard.tasks)[indexPath.row]
        
        tradeDiaryVC.diaryData = row
        tradeDiaryVC.addOrEditAction = .edit
        
        transition(tradeDiaryVC, transitionStyle: .push)
    }
    
}

// MARK: - 기타설정
extension TradeRecordViewController {
    
    @objc func onDidChangeFromDate(sender: UIDatePicker) {
        // 이거 왜 실행이 안되냐
        if sender.date > mainView.toDatePicker.date {
            showAlertMessage(title: "시작일이 종료일보다 클 수 없습니다.")
            return
        }
        
        filteringQualificatinos()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    @objc func onDidChangeToDate(sender: UIDatePicker) {
        
        // 이거 왜 실행이 안되냐
        if sender.date < mainView.fromDatePicker.date {
            showAlertMessage(title: "종료일이 시작일보다 작을 수 없습니다.")
            return
        }
        filteringQualificatinos()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    @objc func buysellChanged() {
        buySellChangedResult()
        filteringQualificatinos()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    func filteringQualificatinos() {
        TradingDiaryRepository.standard.filteredByAllTrading(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date, buySellIndex: mainView.segmentControl.selectedSegmentIndex)
    }
    
    //날짜관련 데이터를 넣자
    func getBuyTotalAmount() -> Int {
        let buyTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return buyTotalAmount
    }
    
    //날짜관련 데이터를 넣자
    func getSellTotalAmount() -> Int {
        let sellTotalAmount = TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)
        return sellTotalAmount
    }
    
    func buySellChangedResult() {
        switch mainView.segmentControl.selectedSegmentIndex {
        case 0:
            getBuyTotal()
            getSellTotal()
        case 1:
            getBuyTotal()
            mainView.totalSellValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
        case 2:
            mainView.totalBuyValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
            getSellTotal()
        default : break
        }
    }
    
    func getBuyTotal() {
        let buyResult = TradingDiaryRepository.standard.getTotalBuyPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
        
        mainView.totalBuyValueLabel.text = "\(thousandSeparatorCommas(value: buyResult)) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func getSellTotal() {
        let sellResult = TradingDiaryRepository.standard.getTotalSellPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
        
        mainView.totalSellValueLabel.text = "\(thousandSeparatorCommas(value: sellResult)) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func isEmptyCheck() {
        if TradingDiaryRepository.standard.tasks.count == 0 {
            self.mainView.tableView.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            self.mainView.tableView.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }
    
}
