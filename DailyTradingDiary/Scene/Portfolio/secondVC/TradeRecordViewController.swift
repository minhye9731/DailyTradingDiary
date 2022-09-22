//
//  TradeRecordViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/22/22.
//

import UIKit

class TradeRecordViewController: BaseViewController {
    
    let mainView = TradeRecordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        self.view.backgroundColor = .systemPink
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    

}

extension TradeRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 렘에서 필터링된 데이터들이 넘어올 것임
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewHeaderView.reuseIdentifier) as? InfoTableViewHeaderView else { return UIView() }
        customHeaderView.sectionTitleLabel.text = "조회내역"
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }

//        tradeCell.setData(arr: Array(tasks), indexPath: indexPath)
                
        // 임시데이터
        tradeCell.nameLabel.text = "TEST"
        tradeCell.amountLabel.text = "1주"
        tradeCell.isTradingLabel.text = "매수"
        tradeCell.priceLabel.text = "(매매단가: 00,000\(Constants.CurrencySign.won.rawValue))"
        
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
