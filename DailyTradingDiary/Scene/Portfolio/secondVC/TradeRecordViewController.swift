//
//  TradeRecordViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit
import RealmSwift
import Toast

final class TradeRecordViewController: BaseViewController {
    
    // MARK: - property
    let mainView = TradeRecordView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TradingDiaryRepository.standard.fetchRealm()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteringQualificatinos()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }
    
    // MARK: - functions
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
        tradeCell.selectionStyle = .none
        
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
        if sender.date > self.mainView.toDatePicker.date {
            self.mainView.makeToast("시작일이 종료일보다 클 수 없습니다. \n 검색일자를 다시 선택해주세요.",  duration: 2.0, position: .center)
            dismiss(animated: true)
            return
        }
        updateData()
    }
    
    @objc func onDidChangeToDate(sender: UIDatePicker) {
        if sender.date < mainView.fromDatePicker.date {
            self.mainView.makeToast("종료일이 시작일보다 작을 수 없습니다. \n 검색일자를 다시 선택해주세요.",  duration: 2.0, position: .center)
            dismiss(animated: true)
            return
        }
        updateData()
    }
    
    @objc func buysellChanged() {
        updateData()
    }
    
    func updateData() {
        buySellChangedResult()
        filteringQualificatinos()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
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
    
    func filteringQualificatinos() {
        TradingDiaryRepository.standard.filteredByAllTrading(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date, buySellIndex: mainView.segmentControl.selectedSegmentIndex)
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
    
    func getBuyTotal() {
        let buyResult = TradingDiaryRepository.standard.getTotalBuyPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
        mainView.totalBuyValueLabel.text = "\(thousandSeparatorCommas(value: buyResult)) \(Constants.CurrencySign.won.rawValue)"
    }
    
    func getSellTotal() {
        let sellResult = TradingDiaryRepository.standard.getTotalSellPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
        mainView.totalSellValueLabel.text = "\(thousandSeparatorCommas(value: sellResult)) \(Constants.CurrencySign.won.rawValue)"
    }
    
}
