////
////  TradingDiaryViewController.swift
////  DailyTradingDiary
////
////  Created by 강민혜 on 9/15/22.
////

import UIKit
import SnapKit
import RealmSwift

final class TradingDiaryViewController: BaseViewController {

    // MARK: - property
    let mainView = TradingDiaryView()
    var addOrEditAction: PageMode = .write

    var diaryData: TradingDiaryRealmModel = TradingDiaryRealmModel(corpName: "매매한 종목 검색하기", corpCode: "000000", tradingPrice: 0, tradingAmount: 0, regDate: Date(), tradingDate: Date(), tradingMemo: "")
    
    var updateData: UpdateTradingDiaryDTO = UpdateTradingDiaryDTO(corpName: "", corpCode: "000000", tradingPrice: 0, tradingAmount: 0, buyAndSell: false, regDate: Date(), tradingDate: Date(), tradingMemo: "")
    
    // MARK: - lifecycle
    override func loadView() {
        self.view = mainView
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        
        // edit 상태에서 아래항목들을 수정하지 않고 저장했을때, 누락되는 경우를 방지하기 위함
        self.updateData.corpName = diaryData.corpName
        self.updateData.corpCode = diaryData.corpCode
        self.updateData.tradingPrice = diaryData.tradingPrice
        self.updateData.tradingAmount = diaryData.tradingAmount
        self.updateData.buyAndSell = diaryData.buyAndSell
        self.updateData.tradingDate = diaryData.tradingDate
        self.updateData.tradingMemo = diaryData.tradingMemo
    }
    
    // MARK: - functions
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
        setNavItem()
    }
}

// MARK: - tableview 설정 관련
extension TradingDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 1
        case 5: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CorpNameTableViewCell.reuseIdentifier) as? CorpNameTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            switch addOrEditAction {
            case .write:
                cell.corpNameLabel.text = diaryData.corpName
                cell.corpNameLabel.textColor = .mainTextColor
            case .edit:
                cell.corpNameLabel.text = updateData.corpName
                cell.corpNameLabel.textColor = .mainTextColor
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "* 매매단가"
            giveColotString(label: cell.nameLabel, colorStr: "*", color: .systemRed)
            
            cell.selectionStyle = .none
            cell.amountTextField.tag = 0
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(thousandSeparatorCommas(value: updateData.tradingPrice))"
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "* 수량"
            giveColotString(label: cell.nameLabel, colorStr: "*", color: .systemRed)
            
            cell.selectionStyle = .none
            cell.amountTextField.tag = 1
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(thousandSeparatorCommas(value: updateData.tradingAmount))"
            }
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySellTableViewCell.reuseIdentifier) as? BuySellTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.segmentControl.tag = 5
            
            if addOrEditAction == .edit {
                cell.segmentControl.selectedSegmentIndex = updateData.buyAndSell ? 1 : 0
            }
            
            cell.segmentTapped = { [self] in
                switch self.addOrEditAction {
                case .write:
                    switch cell.segmentControl.selectedSegmentIndex {
                    case 0: self.diaryData.buyAndSell = false
                    case 1: self.diaryData.buyAndSell = true
                    default: break
                    }
                case .edit:
                    switch cell.segmentControl.selectedSegmentIndex {
                    case 0: self.updateData.buyAndSell = false
                    case 1: self.updateData.buyAndSell = true
                    default: break
                    }
                }
            }
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeDateTableViewCell.reuseIdentifier) as? TradeDateTableViewCell else { return UITableViewCell() }
            print("cellForRowAt - 매매일자 ")
            cell.selectionStyle = .none
            cell.datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
            
            if self.addOrEditAction == .edit {
                cell.datePicker.date = updateData.tradingDate
            }
            return cell
            
        case 5:
            print("cellForRowAt - 메모 ")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.memoTextView.delegate = self
            
            switch addOrEditAction {
            case .write:
                cell.memoTextView.text = Constants.Word.trdDryMemoPlchdr.rawValue
                cell.memoTextView.textColor = .subTextColor
            case .edit:
                if diaryData.tradingMemo == "" {
                    cell.memoTextView.text = Constants.Word.trdDryMemoPlchdr.rawValue
                    cell.memoTextView.textColor = .subTextColor
                } else {
                    cell.memoTextView.text = updateData.tradingMemo
                    cell.memoTextView.textColor = .mainTextColor
                }
            }
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0...4: return 50
        case 5: return 250
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && addOrEditAction == .write {
            let vc = TradingSearchViewController()
            vc.delegate = self
            vc.RegisterOrTrading = .tradingDiary
            transition(vc, transitionStyle: .prsentNavigation)
        }
    }
    
}

// MARK: - textfield delegate
extension TradingDiaryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let result = textField.text else { return }
        if result.count > 13 { textField.deleteBackward() }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        guard var result = textField.text else { return true }
        result = result.replacingOccurrences(of: ",", with: "")
        
        if string.isEmpty {
            // 삭제할 때
            if result.count > 1 {
                guard let num = Int.init("\(result.prefix(result.count - 1))") else { return true }
                guard let resultToShow = formatter.string(from: NSNumber(value: num)) else { return true }
                textField.text = "\(resultToShow)"
                
                switch self.addOrEditAction {
                case .write:
                    switch textField.tag {
                    case 0: self.diaryData.tradingPrice = num
                    case 1: self.diaryData.tradingAmount = num
                    default: break
                    }
                case .edit:
                    switch textField.tag {
                    case 0: self.updateData.tradingPrice = num
                    case 1: self.updateData.tradingAmount = num
                    default: break
                    }
                }

            } else {
                textField.text = ""
            }
        } else if Int(string) != nil {
            // 추가할 때
            guard let num = Int.init("\(result)\(string)") else { return true }
            guard let resultToShow = formatter.string(from: NSNumber(value: num)) else { return true }
            textField.text = "\(resultToShow)"
            
            switch self.addOrEditAction {
            case .write:
                switch textField.tag {
                case 0: self.diaryData.tradingPrice = num
                case 1: self.diaryData.tradingAmount = num
                default: break
                }
            case .edit:
                switch textField.tag {
                case 0: self.updateData.tradingPrice = num
                case 1: self.updateData.tradingAmount = num
                default: break
                }
            }
        }
        return false
    }

}

// MARK: - textview delegate
extension TradingDiaryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = .subTextColor
            textView.text = Constants.Word.trdDryMemoPlchdr.rawValue
        } else if textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
            textView.textColor = .mainTextColor
            textView.text = nil
        }
        textView.textColor = .mainTextColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch addOrEditAction {
        case .write: self.diaryData.tradingMemo = textView.text
        case .edit: self.updateData.tradingMemo = textView.text
        }
        
        if textView.text.count > 300 { textView.deleteBackward() }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
            textView.textColor = .subTextColor
            textView.text = Constants.Word.trdDryMemoPlchdr.rawValue
        }
        
        switch addOrEditAction {
        case .write: self.diaryData.tradingMemo = textView.text
        case .edit: self.updateData.tradingMemo = textView.text
        }
    }
    
}


// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    func setNav() {
        self.navigationItem.title = "매매일지 작성"
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
    
    @objc func doneButtonTapped() {
        
        switch addOrEditAction {
        case .write:
            if diaryData.corpName == "매매한 종목 검색하기" || diaryData.tradingPrice == 0 || diaryData.tradingAmount == 0 {
                self.showAlertMessageDetail(title: "<알림>", message: "필수 입력 항목을 모두 채워주세요.")
                print("tradingPrice - \(diaryData.tradingPrice)")
                print("tradingAmount - \(diaryData.tradingAmount)")
                return
            } else if diaryData.buyAndSell && TradingDiaryRepository.standard.calculateRemainAmountWrite(newTrade: diaryData) < 0 {
                self.showAlertMessageDetail(title: "<알림>", message: "매도금액이 현재 보유중인 자산보다 클 수 없습니다.")
                print(TradingDiaryRepository.standard.calculateRemainAmountWrite(newTrade: diaryData))
                return
            } else {
                diaryData.regDate = Date()
                CorpRegisterRepository.standard.plusDiaryatList(item: diaryData)
                navigationController?.popViewController(animated: true)
            }
        case .edit:
            if updateData.corpName == "매매한 종목 검색하기" || updateData.tradingPrice == 0 || updateData.tradingAmount == 0 {
                self.showAlertMessageDetail(title: "<알림>", message: "필수 입력 항목을 모두 채워주세요.")
                return
            } else if updateData.buyAndSell && TradingDiaryRepository.standard.calculateRemainAmountEdit(originTrade: diaryData, newTrade: updateData) < 0 {
                self.showAlertMessageDetail(title: "<알림>", message: "매도금액이 현재 보유중인 자산보다 클 수 없습니다.")
                print(TradingDiaryRepository.standard.calculateRemainAmountEdit(originTrade: diaryData, newTrade: updateData))
                return
            } else {
                updateData.regDate = Date()
                CorpRegisterRepository.standard.diaryInListupdate(updateTarget: diaryData, updateData: updateData)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setBackButtonName(name: String) {
        let backBarButtonItem = UIBarButtonItem(title: name, style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        switch addOrEditAction {
        case .write:
            self.diaryData.tradingDate = sender.date
        case .edit:
            self.updateData.tradingDate = sender.date
        }
    }
}


extension TradingDiaryViewController: SendDataDelegate {
    func sendData(_ vc: UIViewController, Input value: String, formalName: String, dartCode: String, srtnCode: String) {
        
        print("매매일지로 넘어옴 : \(value), \(formalName), \(dartCode) 선택")
        
        switch addOrEditAction {
        case .write:
            self.diaryData.corpName = value
            self.diaryData.corpCode = srtnCode
        case .edit:
            self.updateData.corpName = value
            self.updateData.corpCode = srtnCode
        }
        self.mainView.tableView.reloadData()
    }
    
}








