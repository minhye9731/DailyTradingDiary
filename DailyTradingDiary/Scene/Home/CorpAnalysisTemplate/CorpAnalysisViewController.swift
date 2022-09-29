//
//  CorpAnalysisViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/28/22.
//

import UIKit
import RealmSwift

class CorpAnalysisViewController: BaseViewController {
    
    let mainView = CorpAnalysis()
    var addOrEditAction: PageMode = .write
    
    var finInfoNameList = ["매출액", "영업이익", "당기순이익", "영업이익률", "순이익률", "부채비율"]
    var dividendeNameList = ["주당배당금", "배당성향"]
    var clickedCorpSum: [StockSummaryModel] = []
    // [StockSummaryModel(updateDate: "----.--.--", corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: " - ", highPrice: " - ", lowPrice: " - ", tradingQnt: " - ", totAmt: " - ")]
    
    var dividendData = DartDividendModel(dps_1yr_bf: "-", dps_2yr_bf: "-", dps_3yr_bf: "-",
                                                 dividend_payout_ratio_1yr_bf: "-", dividend_payout_ratio_2yr_bf: "-", dividend_payout_ratio_3yr_bf: "-")
    
    
    override func loadView() {
        self.view = mainView
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectAPI()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
//        fetchCorpDividendData()
        
        setNav()
        setNavItem()
        
        self.mainView.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    func setNav() {
        self.navigationItem.title = "관심기업 등록"
        self.navigationController?.navigationBar.tintColor = .pointColor
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    func setNavItem() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    func connectAPI() {
//        fetchCorpSumData()
        fetchCorpDividendData()
    }
    
    
}

// MARK: - tableview
extension CorpAnalysisViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 0
        case 2: return 6
        case 3: return 2
        case 4: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 160
        case 1: return 0
        case 2, 3: return 50
        case 4: return 400
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let summaryCell = tableView.dequeueReusableCell(withIdentifier: CorpSummaryTableViewCell.reuseIdentifier) as? CorpSummaryTableViewCell else { return UITableViewCell() }
        summaryCell.selectionStyle = .none
        
        guard let titleNameCell = tableView.dequeueReusableCell(withIdentifier: TitleNameTableViewCell.reuseIdentifier) as? TitleNameTableViewCell else { return UITableViewCell() }
        titleNameCell.selectionStyle = .none
        
        guard let finInfoCell = tableView.dequeueReusableCell(withIdentifier: FinanceInfoTableViewCell.reuseIdentifier) as? FinanceInfoTableViewCell else { return UITableViewCell() }
        finInfoCell.selectionStyle = .none
        
        guard let opinionCell = tableView.dequeueReusableCell(withIdentifier: OpinionTableViewCell.reuseIdentifier) as? OpinionTableViewCell else { return UITableViewCell() }
        opinionCell.selectionStyle = .none
        
        
        switch indexPath.section {
        case 0:
//            summaryCell.setData(data: self.clickedCorpSum, indexPath: indexPath)
            return summaryCell
        case 1: return summaryCell
        case 2:
            finInfoCell.nameLabel.text = finInfoNameList[indexPath.row]
            return finInfoCell
        case 3:
            finInfoCell.nameLabel.text = dividendeNameList[indexPath.row]
            finInfoCell.setDividendData(data: self.dividendData, indexPath: indexPath)
            
            return finInfoCell
        case 4:
            opinionCell.opinionTextView.delegate = self
            
            opinionCell.eBuyTextField.delegate = self
            opinionCell.eBuyTextField.tag = 0
            opinionCell.eBuyDatePicker.tag = 0
            
            opinionCell.eSellTextField.delegate = self
            opinionCell.eSellTextField.tag = 1
            opinionCell.eSellDatePicker.tag = 1
            
            opinionCell.eBuyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            opinionCell.eBuyDatePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
            
            opinionCell.eSellTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            opinionCell.eSellDatePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
            
            return opinionCell
        default: return summaryCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        switch section {
        case 0: customHeaderView.sectionTitleLabel.text = "종합"
        case 1: customHeaderView.sectionTitleLabel.text = "주요재무"
        case 2, 3: customHeaderView.sectionTitleLabel.text = "항목명" // 이거 다른셀로 커스텀해서 적용
        case 4: customHeaderView.sectionTitleLabel.text = "My Opinion"
        default: customHeaderView.sectionTitleLabel.text = ""
        }
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

// MARK: - opinionTextView 설정
extension CorpAnalysisViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        //            textView.textColor = .subTextColor
        //            textView.text = Constants.Word.trdDryMemoPlchdr.rawValue
        //        } else if textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
        //            textView.textColor = .mainTextColor
        //            textView.text = nil
        //        }
        //        textView.textColor = .mainTextColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //        switch addOrEditAction {
        //        case .write:
        //                self.diaryData.tradingMemo = textView.text
        //        case .edit:
        //            self.updateData.tradingMemo = textView.text
        //        }
        
        if textView.text.count > 300 {
            textView.deleteBackward()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
        //            textView.textColor = .subTextColor
        //            textView.text = Constants.Word.trdDryMemoPlchdr.rawValue
        //        }
        //
        //        switch addOrEditAction {
        //        case .write:
        //                self.diaryData.tradingMemo = textView.text
        //        case .edit:
        //            self.updateData.tradingMemo = textView.text
        //        }
    }
    
}

// MARK: - textfield 설정
extension CorpAnalysisViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - 기타 함수
extension CorpAnalysisViewController {
    
    @objc func doneButtonTapped() {
        print("저장 완료!")
    }
    
    @objc func searchButtonClicked() {
        print("검색 버튼이 눌렸다!")
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        print("입력한 희망 가격이 바뀌었다!")
        // tag로 구분해서 저장하자
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        print("선택한 날짜가 바뀌었다!")
        // tag로 구분해서 저장하자
    }
    
    func fetchCorpSumData() {
        APISAPIManager.shared.fetchApisStockAPI(type: .apisStockInfo, baseDate: "20220928", clickText: "삼성전자") { (response) in
            
            switch(response) {
            case .success(let result):
                
                if let data = result as? [Item] {
                    
                    let stockDataArray: [StockSummaryModel] = data.map { data -> StockSummaryModel in
                        
                        let update = data.basDt
                        let name = data.itmsNm
                        let market = data.mrktCtg
                        let code = data.srtnCD
                        let now = data.mkp
                        let high = data.hipr
                        let low = data.lopr
                        let quantity = data.trqu
                        let total = data.mrktTotAmt
                        
                        return StockSummaryModel(updateDate: update, corpName: name, marketName: market, srtnCode: code, nowPrice: now, highPrice: high, lowPrice: low, tradingQnt: quantity, totAmt: total)
                    }
                    print("stockDataArray: \(stockDataArray)")
                    
                    
                    
                    self.clickedCorpSum.append(contentsOf: stockDataArray)
                    print("clickedCorpSum: \(self.clickedCorpSum)")
                    
                    DispatchQueue.main.async  {
                        self.mainView.tableView.reloadData()
                    }
                }
                
            case .requestErr(let message) :
                print("requestErr")
                self.showAlertMessageDetail(title: "요청 에러가 발생했습니다.", message: "\(message)")
            case .pathErr :
                self.showAlertMessageDetail(title: "<알림>", message: "요청 경로가 잘못되었습니다. 잠시 후 재시도해 주세요 :)")
            case .serverErr :
                self.showAlertMessageDetail(title: "<알림>", message: "서버 에러가 발생했습니다. 잠시 후 재시도해 주세요 :)")
            case .networkFail :
                self.showAlertMessageDetail(title: "<알림>", message: "네트워크 통신 에러가 발생했습니다. 인터넷 환경을 확인 후 재시도해 주세요 :)")
            }
        }
    }
    
    // 배당금 api 통신
    func fetchCorpDividendData() {
        DARTAPIManager.shared.fetchDividendAPI(type: .dartDivdInfo, dartCropCode: "00126380", year: "2021") { data in
            
            print("fetchCorpDividendData data: \(data)")
            self.dividendData = data

            print("fetchCorpDividendData dividendData: \(self.dividendData)")
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
        
    }
    
}
    
