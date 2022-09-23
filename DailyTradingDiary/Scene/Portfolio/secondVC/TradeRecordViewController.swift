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
        print("TradeRecordViewController - \(#function)")
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TradeRecordViewController - \(#function)")
        
        TradingDiaryRepository.standard.fetchRealm()
        
                buySellChangedResult()
                filteringQualificatinos()
        self.mainView.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteringQualificatinos()
        print("TradeRecordViewController - \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TradeRecordViewController - \(#function)")
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.fromDatePicker.addTarget(self, action: #selector(onDidChangeFromDate(sender:)), for: .valueChanged)
        mainView.toDatePicker.addTarget(self, action: #selector(onDidChangeToDate(sender:)), for: .valueChanged)
        mainView.segmentControl.addTarget(self, action: #selector(buysellChanged), for: .valueChanged)
    }
    
    @objc func onDidChangeFromDate(sender: UIDatePicker) {
        print("onDidChangeFromDate가 눌림! \(sender.date)")
        
        // 이거 왜 실행이 안되냐
        if sender.date > mainView.toDatePicker.date {
            showAlertMessage(title: "시작일이 종료일보다 클 수 없습니다.")
            return
        }
        
        filteringQualificatinos()
        self.mainView.tableView.reloadData()
    }
    
    @objc func onDidChangeToDate(sender: UIDatePicker) {
        print("onDidChangeToDate가 눌림! \(sender.date)")
        if sender.date < mainView.fromDatePicker.date {
            showAlertMessage(title: "종료일이 시작일보다 작을 수 없습니다.")
            return
        }
        filteringQualificatinos()
        self.mainView.tableView.reloadData()
    }
    
    @objc func buysellChanged() {
        buySellChangedResult()
        filteringQualificatinos()
        self.mainView.tableView.reloadData()
    }
    func filteringQualificatinos() {
        TradingDiaryRepository.standard.filteredByAllTrading(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date, buySellIndex: mainView.segmentControl.selectedSegmentIndex)
    }
    
    //    func filteringQualificatinos() {
    //        TradingDiaryRepository.standard.filteredByAllTrading(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date, buySellIndex: mainView.segmentControl.selectedSegmentIndex)
    //    }
    
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
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewHeaderView.reuseIdentifier) as? InfoTableViewHeaderView else { return UIView() }
        customHeaderView.sectionTitleLabel.text = "조회내역"
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }
        
        tradeCell.setData(arr: Array(TradingDiaryRepository.standard.tasks), indexPath: indexPath)
        
        return tradeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 째 셀을 클릭했습니다. 해당 생성파일의 보기으로 넘어감")
        
        //        let tradeDiaryVC = TradingDiaryViewController()
        //        let row = Array(tasks)[indexPath.row]
        //
        //        tradeDiaryVC.diaryData = row
        //        tradeDiaryVC.addOrEditAction = .edit // enum 내역 하나 더 추가해서 화면 재사용 3번째 : 차이점은 완료&뒤로가기하면 포트폴리오로 넘어오도록.
        //
        //        transition(tradeDiaryVC, transitionStyle: .push)
    }
    
}

// MARK: - 기타설정
extension TradeRecordViewController {
    
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
            mainView.profitLossValueLabel.text = "구현중"
        case 1:
            getBuyTotal()
            mainView.totalSellValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
            mainView.profitLossValueLabel.text = "0\(Constants.CurrencySign.won.rawValue) (0.00%)"
        case 2:
            mainView.totalBuyValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
            getSellTotal()
            mainView.profitLossValueLabel.text = "구현중"
        default : break
        }
        
        //        switch mainView.segmentControl.selectedSegmentIndex {
        //        case 0:
        //            mainView.totalBuyValueLabel.text = "\(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)) \(Constants.CurrencySign.won.rawValue)"
        //            mainView.totalSellValueLabel.text = "\(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)) \(Constants.CurrencySign.won.rawValue)"
        //            mainView.profitLossValueLabel.text = "구현중"
        //        case 1:
        //            mainView.totalBuyValueLabel.text = "\(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == false }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)) \(Constants.CurrencySign.won.rawValue)"
        //            mainView.totalSellValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
        //            mainView.profitLossValueLabel.text = "0\(Constants.CurrencySign.won.rawValue) (0.00%)"
        //        case 2:
        //            mainView.totalBuyValueLabel.text = "0 \(Constants.CurrencySign.won.rawValue)"
        //            mainView.totalSellValueLabel.text = "\(TradingDiaryRepository.standard.tasks.where { $0.buyAndSell == true }.map { $0.tradingPrice * $0.tradingAmount }.reduce(0, +)) \(Constants.CurrencySign.won.rawValue)"
        //            mainView.profitLossValueLabel.text = "구현중"
        //        default : break
        //        }
        
        func getBuyTotal() {
            let buyResult = TradingDiaryRepository.standard.getTotalBuyPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
            
            mainView.totalBuyValueLabel.text = "\(thousandSeparatorCommas(value: buyResult)) \(Constants.CurrencySign.won.rawValue)"
        }
        
        func getSellTotal() {
            let sellResult = TradingDiaryRepository.standard.getTotalSellPrice(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date)
            
            mainView.totalSellValueLabel.text = "\(thousandSeparatorCommas(value: sellResult)) \(Constants.CurrencySign.won.rawValue)"
        }
        
        
//        func filteringQualificatinos() {
//            TradingDiaryRepository.standard.filteredByAllTrading(from: mainView.fromDatePicker.date, to: mainView.toDatePicker.date, buySellIndex: mainView.segmentControl.selectedSegmentIndex)
//        }
        
        func thousandSeparatorCommas(value: Int) -> String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(for: value) ?? "0"
        }
        
        
        
    }
}
