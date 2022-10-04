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
    var finInfoNameList = ["매출액", "영업이익", "당기순이익", "부채총계", "자본총계"]
    var dividendeNameList = ["주당배당금", "배당성향"]
    var registeredSrtnCdArr: [String] = []
    
    // api 통신시에 담아줄 데이터
    var clickedCorpSum: [StockSummaryDTO] = [StockSummaryDTO(updateDate: " 00000000 ", corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: " - ", highPrice: " - ", lowPrice: " - ", tradingQnt: " - ", totAmt: " - ")]
    var finStatementDataArr: [DartFinInfoDTO] = [
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-")]
    var dividendDataArr: [DartDividendDTO] = [
        DartDividendDTO(labelName: "-", stockKind: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartDividendDTO(labelName: "-", stockKind: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-")]
    
    // api refresh시 담아줄 데이터
    var refreshClickedCorpSum: [StockSummaryDTO] = [StockSummaryDTO(updateDate: " 00000000 ", corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: " - ", highPrice: " - ", lowPrice: " - ", tradingQnt: " - ", totAmt: " - ")]
    var refreshFinStatementDataArr: [DartFinInfoDTO] = [
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartFinInfoDTO(sjName: "-", labelID: "-", labelName: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-")]
    var refreshdividendDataArr: [DartDividendDTO] = [
        DartDividendDTO(labelName: "-", stockKind: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-"),
        DartDividendDTO(labelName: "-", stockKind: "-", amount_1yr_bf: "-", amount_2yr_bf: "-", amount_3yr_bf: "-")]
    
    // 신규작성&업데이트시 데이터를 상세하게 다루기 위해 잠시 담아둘 Realm용 변수
    var newRegisterData: CorpRegisterRealmModel = CorpRegisterRealmModel(formalCorpName: "(기업명)", updateDate: Date(), corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: 0, highPrice: 0, lowPrice: 0, tradingQnt: 0, totAmt: 0, revenueThr: 0, revenueTwo: 0, revenueOne: 0, opIncomeThr: 0, opIncomeTwo: 0, opIncomeOne: 0, nProfitThr: 0, nProfitTwo: 0, nProfitOne: 0, totalDebtThr: 0, totalDebtTwo: 0, totalDebtOne: 0, totalCapThr: 0, totalCapTwo: 0, totalCapOne: 0, dpsThr: 0, dpsTwo: 0, dpsOne: 0, diviPayoutRatioThr: 0.0, diviPayoutRatioTwo: 0.0, diviPayoutRatioOne: 0.0, regDate: Date(), opinion: "", buyPricePlan: 0, buyDatePlan: Date(), sellPricePlan: 0, sellDatePlan: Date())
    var updateRegisteredData: CorpRegisterRealmModel = CorpRegisterRealmModel(formalCorpName: "(기업명)", updateDate: Date(), corpName: " - ", marketName: " - ", srtnCode: "000000", nowPrice: 0, highPrice: 0, lowPrice: 0, tradingQnt: 0, totAmt: 0, revenueThr: 0, revenueTwo: 0, revenueOne: 0, opIncomeThr: 0, opIncomeTwo: 0, opIncomeOne: 0, nProfitThr: 0, nProfitTwo: 0, nProfitOne: 0, totalDebtThr: 0, totalDebtTwo: 0, totalDebtOne: 0, totalCapThr: 0, totalCapTwo: 0, totalCapOne: 0, dpsThr: 0, dpsTwo: 0, dpsOne: 0, diviPayoutRatioThr: 0.0, diviPayoutRatioTwo: 0.0, diviPayoutRatioOne: 0.0, regDate: Date(), opinion: "", buyPricePlan: 0, buyDatePlan: Date(), sellPricePlan: 0, sellDatePlan: Date())
    
    // MARK: - lifecycle
    override func loadView() {
        self.view = mainView
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        
        // edit 상태에서 아래항목들을 수정하지 않고 저장했을때, 누락되는 경우를 방지하기 위함
        self.updateRegisteredData = newRegisterData
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
        setNavItem()
        setSearchBtn()
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
        case 2: return 5
        case 3: return 2
        case 4: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 70 // 160
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
        
        // 종합
        case 0:
            summaryCell.selectionStyle = .none
            switch addOrEditAction {
            case .write:
                summaryCell.setData(data: self.clickedCorpSum, indexPath: indexPath) // view에 데이터 표시
                mergeCorpSumData(wholeData: newRegisterData, corpData: clickedCorpSum) // 데이터 merge
            case .edit:
                summaryCell.setData(data: self.refreshClickedCorpSum, indexPath: indexPath) // view에 데이터 표시
                mergeCorpSumData(wholeData: updateRegisteredData, corpData: refreshClickedCorpSum) // 데이터 merge
            }
            return summaryCell
        
        // (주요제무) - 제목으로 쓸거라 어차피 높이0으로 cell은 안보임
        case 1: return summaryCell
        
        // 실제 주요제무 데이터
        case 2:
            finInfoCell.selectionStyle = .none
            finInfoCell.nameLabel.text = finInfoNameList[indexPath.row]
            switch addOrEditAction {
            case .write:
                finInfoCell.setFinStatementData(data: self.finStatementDataArr, indexPath: indexPath) // view에 데이터 표시
                mergeFinStatData(wholeData: newRegisterData, finData: finStatementDataArr) // 데이터 merge
            case .edit:
                finInfoCell.setFinStatementData(data: self.refreshFinStatementDataArr, indexPath: indexPath) // view에 데이터 표시
                mergeFinStatData(wholeData: updateRegisteredData, finData: refreshFinStatementDataArr) // 데이터 merge
            }
            return finInfoCell
        
        // 실제 배당 데이터
        case 3:
            finInfoCell.selectionStyle = .none
            finInfoCell.nameLabel.text = dividendeNameList[indexPath.row]
            
            switch addOrEditAction {
            case .write:
                finInfoCell.setDividendData(data: self.dividendDataArr, indexPath: indexPath) // view에 데이터 표시
                mergeDividData(wholeData: newRegisterData, dividData: dividendDataArr) // 데이터 merge
            case .edit:
                finInfoCell.setDividendData(data: self.refreshdividendDataArr, indexPath: indexPath) // view에 데이터 표시
                mergeDividData(wholeData: updateRegisteredData, dividData: refreshdividendDataArr) // 데이터 merge
            }
            return finInfoCell
            
        // My Opinion
        case 4:
            opinionCell.selectionStyle = .none
            opinionCell.opinionTextView.delegate = self
            
            opinionCell.eBuyTextField.delegate = self
            opinionCell.eBuyTextField.tag = 0
            opinionCell.eBuyDatePicker.tag = 0
            
            opinionCell.eSellTextField.delegate = self
            opinionCell.eSellTextField.tag = 1
            opinionCell.eSellDatePicker.tag = 1
            
            // textView
            switch addOrEditAction {
            case .write:
                opinionCell.opinionTextView.text = Constants.Word.corpRigMemoPlchdr.rawValue
                opinionCell.opinionTextView.textColor = .subTextColor
            case .edit:
                if newRegisterData.opinion == "" {
                    opinionCell.opinionTextView.text = Constants.Word.corpRigMemoPlchdr.rawValue
                    opinionCell.opinionTextView.textColor = .subTextColor
                } else {
                    opinionCell.opinionTextView.text = updateRegisteredData.opinion
                    opinionCell.opinionTextView.textColor = .mainTextColor
                }
            }
            
            // textField
            if addOrEditAction == .edit {
                opinionCell.eBuyTextField.text = "\(String(describing: self.updateRegisteredData.buyPricePlan))"
                opinionCell.eSellTextField.text = "\(String(describing: self.updateRegisteredData.sellPricePlan))"
            }
            
            // datePicker (불확실, Test 필요)
            if addOrEditAction == .edit {
                opinionCell.eBuyDatePicker.date = self.updateRegisteredData.buyDatePlan
                opinionCell.eSellDatePicker.date = self.updateRegisteredData.sellDatePlan
            }
            
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
        guard let customListNameHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContentTableViewHeaderView.reuseIdentifier) as? ContentTableViewHeaderView else { return UIView() }
        
        switch section {
        case 0:
            customHeaderView.sectionTitleLabel.text = "종합"
            return customHeaderView
        case 1:
            customHeaderView.sectionTitleLabel.text = "주요재무"
            return customHeaderView
        case 2, 3: return customListNameHeaderView
        case 4:
            customHeaderView.sectionTitleLabel.text = "My Opinion"
            return customHeaderView
        default:
            customHeaderView.sectionTitleLabel.text = ""
            return customHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

// MARK: - opinionTextView 설정
extension CorpAnalysisViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = .subTextColor
            textView.text = Constants.Word.corpRigMemoPlchdr.rawValue
        } else if textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
            textView.textColor = .mainTextColor
            textView.text = ""
        }
        textView.textColor = .mainTextColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch addOrEditAction {
        case .write:
            self.newRegisterData.opinion = textView.text
        case .edit:
            self.updateRegisteredData.opinion = textView.text
        }
        
        if textView.text.count > 300 {
            textView.deleteBackward()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == Constants.Word.corpRigMemoPlchdr.rawValue {
            textView.textColor = .subTextColor
            textView.text = Constants.Word.corpRigMemoPlchdr.rawValue
        }
        
        switch addOrEditAction {
        case .write:
            self.newRegisterData.opinion = textView.text
        case .edit:
            self.updateRegisteredData.opinion = textView.text
        }
    }
    
}

// MARK: - textfield 설정
extension CorpAnalysisViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        print("입력한 희망 가격이 바뀌었다!")
        guard let result = sender.text else { return }
        
        switch self.addOrEditAction {
        case .write:
            switch sender.tag {
            case 0: self.newRegisterData.buyPricePlan = Int(result)
            case 1: self.newRegisterData.sellPricePlan = Int(result)
            default: break
            }
        case .edit:
            switch sender.tag {
            case 0: self.updateRegisteredData.buyPricePlan = Int(result)
            case 1: self.updateRegisteredData.sellPricePlan = Int(result)
            default: break
            }
        }
    }
    
}

// MARK: - 기타 함수
extension CorpAnalysisViewController {
    
    @objc func doneButtonTapped() {
        
        // edit 모드 분기처리는 update 때 추가예정
        self.registeredSrtnCdArr = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { $0.srtnCode }
        print("registeredSrtnCdArr : \(registeredSrtnCdArr)")
        
        if self.newRegisterData.srtnCode == "000000" {
            self.showAlertMessageDetail(title: "<알림>", message: "등록할 기업데이터가 없습니다. 기업명을 검색하여 관심기업 정보를 기입해주세요.")
            return
        } else if self.registeredSrtnCdArr.contains(newRegisterData.srtnCode) {
            self.showAlertMessageDetail(title: "<알림>", message: "이미 등록되어 있는 기업입니다.")
            return
        } else {
            newRegisterData.regDate = Date()
            CorpRegisterRepository.standard.plusRegisterCorp(item: newRegisterData)
            presentAlert(title: "\(newRegisterData.corpName) 이 관심기업으로 등록되었습니다.", message: "해당 기업의 매매일지를 작성할 수 있습니다! :)", preferredStyle: .alert) {_ in
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    @objc func searchButtonClicked() {
        print("검색 버튼이 눌렸다!")
        let vc = TradingSearchViewController()
        vc.RegisterOrTrading = .registerCorp
        vc.delegate = self
        transition(vc, transitionStyle: .prsentNavigation)
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        print("선택한 날짜가 바뀌었다!")
        
        switch addOrEditAction {
        case .write:
            switch sender.tag {
            case 0: self.newRegisterData.buyDatePlan = sender.date
            case 1: self.newRegisterData.sellDatePlan = sender.date
            default : break
            }
        case .edit:
            switch sender.tag {
            case 0: self.updateRegisteredData.buyDatePlan = sender.date
            case 1: self.updateRegisteredData.sellDatePlan = sender.date
            default : break
            }
        }
        
    }

    
    // corpSum 데이터를 relam용 큰변수에 합치기
    func mergeCorpSumData(wholeData: CorpRegisterRealmModel, corpData: [StockSummaryDTO] ) {
        wholeData.updateDate = corpData[0].updateDate.toDateforAPI() ?? Date()
        wholeData.corpName = corpData[0].corpName
        wholeData.marketName = corpData[0].marketName
        wholeData.srtnCode = corpData[0].srtnCode
        wholeData.nowPrice = Int(corpData[0].nowPrice) ?? 0
        wholeData.highPrice = Int(corpData[0].highPrice) ?? 0
        wholeData.lowPrice = Int(corpData[0].lowPrice) ?? 0
        wholeData.tradingQnt = Int(corpData[0].tradingQnt) ?? 0
        wholeData.totAmt = Int(corpData[0].totAmt) ?? 0
    }
   
    // finstat 데이터를 relam용 큰변수에 합치기
    func mergeFinStatData(wholeData: CorpRegisterRealmModel,finData: [DartFinInfoDTO] ) {
        
        wholeData.revenueThr = Int(finData[0].amount_3yr_bf)
        wholeData.revenueTwo = Int(finData[0].amount_2yr_bf)
        wholeData.revenueOne = Int(finData[0].amount_1yr_bf)
        
        wholeData.opIncomeThr = Int(finData[1].amount_3yr_bf)
        wholeData.opIncomeTwo = Int(finData[1].amount_2yr_bf)
        wholeData.opIncomeOne = Int(finData[1].amount_1yr_bf)
        
        wholeData.nProfitThr = Int(finData[2].amount_3yr_bf)
        wholeData.nProfitTwo = Int(finData[2].amount_2yr_bf)
        wholeData.nProfitOne = Int(finData[2].amount_1yr_bf)
        
        wholeData.totalDebtThr = Int(finData[3].amount_3yr_bf)
        wholeData.totalDebtTwo = Int(finData[3].amount_2yr_bf)
        wholeData.totalDebtOne = Int(finData[3].amount_1yr_bf)
        
        wholeData.totalCapThr = Int(finData[4].amount_3yr_bf)
        wholeData.totalCapTwo = Int(finData[4].amount_2yr_bf)
        wholeData.totalCapOne = Int(finData[4].amount_1yr_bf)
    }
    
    // divi 데이터를 relam용 큰변수에 합치기
    func mergeDividData(wholeData: CorpRegisterRealmModel, dividData: [DartDividendDTO] ) {
        
//        wholeData.dpsThr = Int(dividData[0].amount_3yr_bf.replacingOccurrences(of: ",", with: ""))
//        wholeData.dpsTwo = Int(dividData[0].amount_2yr_bf.replacingOccurrences(of: ",", with: ""))
//        wholeData.dpsOne = Int(dividData[0].amount_1yr_bf.replacingOccurrences(of: ",", with: ""))
        
        wholeData.dpsThr = dividData[0].amount_3yr_bf == "-" ? 0 : Int(dividData[0].amount_3yr_bf.replacingOccurrences(of: ",", with: ""))
        wholeData.dpsTwo = dividData[0].amount_2yr_bf == "-" ? 0 : Int(dividData[0].amount_2yr_bf.replacingOccurrences(of: ",", with: ""))
        wholeData.dpsOne = dividData[0].amount_1yr_bf == "-" ? 0 : Int(dividData[0].amount_1yr_bf.replacingOccurrences(of: ",", with: ""))
        
        wholeData.diviPayoutRatioThr = dividData[1].amount_3yr_bf == "-" ? 0.0 : Double(dividData[1].amount_3yr_bf)
        wholeData.diviPayoutRatioTwo =  dividData[1].amount_2yr_bf == "-" ? 0.0 : Double(dividData[1].amount_2yr_bf)
        wholeData.diviPayoutRatioOne =  dividData[1].amount_2yr_bf == "-" ? 0.0 : Double(dividData[1].amount_2yr_bf)
    }
    
}
    
extension CorpAnalysisViewController: SendDataDelegate {
    
    func sendData(_ vc: UIViewController, Input value: String, formalName: String, dartCode code: String, srtnCode: String) {
        print("관심기업 등록 화면 : \(value), \(formalName), \(code) 기업을 선택하셨습니다!")
        self.mainView.nameResultLabel.text = formalName
        newRegisterData.formalCorpName = formalName
        
        connectAPI(name: value, dartcode: code)
    }
    
    func connectAPI(name: String, dartcode: String) {
        self.fetchCorpFinInfoData(dartCode: dartcode)
        self.fetchCorpDividendData(dartCode: dartcode)
        self.fetchCorpSumData(corpName: name)
    }
    
    // corpname 기준으로 '공공데이터-주가시세정보' API 통신
    func fetchCorpSumData(corpName: String) {
        
        APISAPIManager.shared.fetchApisStockAPI(type: .apisStockInfo, clickText: corpName) { (response) in
            
            switch(response) {
            case .success(let result):
                
                if let data = result as? [Item] {
                    
                    let stockDataArray: [StockSummaryDTO] = data.map { data -> StockSummaryDTO in
                        let update = data.basDt
                        let name = data.itmsNm
                        let market = data.mrktCtg
                        let code = data.srtnCD
                        let now = data.mkp
                        let high = data.hipr
                        let low = data.lopr
                        let quantity = data.trqu
                        let total = data.mrktTotAmt
                        
                        return StockSummaryDTO(updateDate: update, corpName: name, marketName: market, srtnCode: code, nowPrice: now, highPrice: high, lowPrice: low, tradingQnt: quantity, totAmt: total)
                    }
                    
                        switch self.addOrEditAction {
                        case .write :
                            self.clickedCorpSum.removeAll()
                            self.clickedCorpSum.append(contentsOf: stockDataArray)
                            print("종합정보: \(self.clickedCorpSum)")
                            
                        case .edit :
                            self.refreshClickedCorpSum.removeAll()
                            self.refreshClickedCorpSum.append(contentsOf: stockDataArray)
                            print("refresh 종합정보: \(self.refreshClickedCorpSum)")
                        }

                    DispatchQueue.main.async  {
                        self.mainView.tableView.reloadData()
                    }
                }
                
            case .requestErr(let message) :
                print("requestErr")
                self.showAlertMessageDetail(title: "요청 에러가 발생했습니다.", message: "\(message)")
                break
            case .pathErr :
                self.showAlertMessageDetail(title: "<알림>", message: "요청 경로가 잘못되었습니다. 잠시 후 재시도해 주세요 :)")
                break
            case .serverErr :
                self.showAlertMessageDetail(title: "<알림>", message: "서버 에러가 발생했습니다. 잠시 후 재시도해 주세요 :)")
                break
            case .networkFail :
                self.showAlertMessageDetail(title: "<알림>", message: "네트워크 통신 에러가 발생했습니다. 인터넷 환경을 확인 후 재시도해 주세요 :)")
                break
            }
        }
    }
    
    // corpcode 기준으로 'DART-단일회사 전체 재무제표 개발가이드' API 통신
    func fetchCorpFinInfoData(dartCode: String) {
        DARTAPIManager.shared.fetchFinInfoAPI(type: .dartFinInfo, dartCropCode: dartCode, year: getLastYear()) { finInfoArr in
            
            if finInfoArr.isEmpty {
                self.showAlertMessageDetail(title: "<알림>", message: "검색하신 기업의 재무제표 데이터가 없습니다. 다른 기업으로 재검색해 주세요 :)")
                return
            } else {
                
                print("\(finInfoArr[0])")
                let revenueData = finInfoArr.filter { $0.labelID == "ifrs-full_Revenue" }
                print("revenueData : \(revenueData)")
                // 매출액
                let opIncomeData = finInfoArr.filter { $0.labelID == "dart_OperatingIncomeLoss" } // 영업이익
                print("opIncomeData : \(opIncomeData)")
                
                let netProfitData = finInfoArr.filter { $0.sjName.contains("포괄손익계산서") && $0.labelID == "ifrs-full_ProfitLoss" } // 당기순이익
                print("netProfitData : \(netProfitData)")
                
                let fullLiabilData = finInfoArr.filter { $0.labelID == "ifrs-full_Liabilities" } // 부채총계
                print("fullLiabilData : \(fullLiabilData)")
                
                let fullEqtData = finInfoArr.filter { $0.sjName.contains("재무상태표") && $0.labelID == "ifrs-full_Equity" } // 자본총계
                print("fullEqtData : \(fullEqtData)")
                
                switch self.addOrEditAction {
                case .write :
                    self.finStatementDataArr.removeAll()
                    [revenueData, opIncomeData, netProfitData, fullLiabilData, fullEqtData].forEach {
                        self.finStatementDataArr.append(contentsOf: $0)
                    }
                    print("재무제표 데이터: \(self.finStatementDataArr)")
                case .edit :
                    self.refreshFinStatementDataArr.removeAll()
                    [revenueData, opIncomeData, netProfitData, fullLiabilData, fullEqtData].forEach {
                        self.refreshFinStatementDataArr.append(contentsOf: $0)
                    }
                    print("refresh 재무제표 데이터: \(self.refreshFinStatementDataArr)")
                }
            }
            DispatchQueue.main.async { self.mainView.tableView.reloadData() }
        }
    }
    
    // corpcode 기준으로 'DART-배당에 관한 사항' API 통신
    func fetchCorpDividendData(dartCode: String) {
        DARTAPIManager.shared.fetchDividendAPI(type: .dartDivdInfo, dartCropCode: dartCode, year: getLastYear()) { diviInfoArr in
            
            if diviInfoArr.isEmpty {
                self.showAlertMessageDetail(title: "<알림>", message: "검색하신 기업은 배당금 데이터가 없습니다.")
                return
            } else {
                print("\(diviInfoArr[0])")
                
                // 주당 현금배당금
                let dpsData = diviInfoArr.filter { $0.labelName == "주당 현금배당금(원)" }[0]
                print("dpsData : \(dpsData)")

                // 배당성향
                let pyRioData = diviInfoArr.filter { $0.labelName == "(연결)현금배당성향(%)" }[0]
                print("opIncomeData : \(pyRioData)")
                
                switch self.addOrEditAction {
                case .write :
                    self.dividendDataArr.removeAll()
//                    [dpsData, pyRioData].forEach {
//                        self.dividendDataArr.append(contentsOf: $0)
//                    }
                    [dpsData, pyRioData].forEach {
                        self.dividendDataArr.append($0)
                    }
                    
                    
                    
                    print("배당금 데이터 : \(self.dividendDataArr)")
                case .edit :
                    self.refreshdividendDataArr.removeAll()
//                    [dpsData, pyRioData].forEach {
//                        self.refreshdividendDataArr.append(contentsOf: $0)
//                    }
                    [dpsData, pyRioData].forEach {
                        self.refreshdividendDataArr.append($0)
                    }
                    
                    print("refresh 배당금 데이터: \(self.refreshdividendDataArr)")
                }
            }
            DispatchQueue.main.async { self.mainView.tableView.reloadData() }
        }
    }
    
    func getLastYear() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let lastYear = String(currentYear - 1)
        print("lastYear : \(lastYear)")
        return lastYear
    }
    
    func setSearchBtn() {
        if addOrEditAction == .write {
            let searchButton: UIButton = {
                let button = UIButton()
                button.setImage(UIImage(systemName: Constants.ImageName.magnifyingGlass.rawValue), for: .normal)
                button.tintColor = .mainTextColor
                button.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
                return button
            }()
            
            self.mainView.addSubview(searchButton)
            
            searchButton.snp.makeConstraints { make in
                make.trailing.equalTo(mainView.selectCorpView.snp.trailing).offset(-27)
                make.centerY.equalTo(mainView.selectCorpView)
            }
            
        }
    }
    
}






