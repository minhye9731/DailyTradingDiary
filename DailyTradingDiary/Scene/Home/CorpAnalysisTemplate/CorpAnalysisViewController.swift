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
    
    var finInfoNameList = ["매출액", "영업이익", "당기순이익", "영업이익률", "순이익률", "ROE", "부채비율", "유보율", "매출채권 회전율", "재고자산 회전율", "주당배당금", "배당성향"]
    var clickedCorpSum: StockSummaryModel = StockSummaryModel(updateDate: "----.--.--", corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: " - ", highPrice: " - ", lowPrice: " - ", tradingQnt: " - ", totAmt: " - ")
    
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
        fetchCorpSumData()

    }
    
    
}

// MARK: - tableview
extension CorpAnalysisViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 13
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 160
        case 1: return 50
        case 2: return 400
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
            summaryCell.setData(data: clickedCorpSum)
            return summaryCell
        case 1:
            if indexPath.row == 0 {
                return titleNameCell
            }
            //            finInfoCell.nameLabel.text = finInfoNameList[indexPath.row + 1]
            //            for name in finInfoNameList {
            //                finInfoCell.nameLabel.text = name
            //            }
            //
            //            finInfoNameList.forEach {
            //                finInfoCell.nameLabel.text = $0
            //            }
            //
            return finInfoCell
            
        case 2:
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
        case 2: customHeaderView.sectionTitleLabel.text = "My Opinion"
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
            case .success(let data):
            
                print("data: \(data)")
                
                guard let result = data as? Item else { return }
                
                let update = result.basDt
                let name = result.itmsNm
                let market = result.mrktCtg
                let code = result.srtnCD
                let now = result.mkp
                let high = result.hipr
                let low = result.lopr
                let quantity = result.trqu
                let total = result.mrktTotAmt
                
                self.clickedCorpSum = StockSummaryModel(updateDate: update, corpName: name, marketName: market, srtnCode: code, nowPrice: now, highPrice: high, lowPrice: low, tradingQnt: quantity, totAmt: total)

                // 나중에는 기업검색을 하고 돌아오면서, 통신해서 보여줄 것이므로 보이는 시기 재수정 예정
                DispatchQueue.main.asyncAfter(deadline: .now() + 6)  {
                    self.mainView.tableView.reloadData()
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
    
}
