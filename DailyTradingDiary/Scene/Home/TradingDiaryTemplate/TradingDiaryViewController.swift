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
    
    override func configure() {
        print(#function)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        setNav()
        setNavItem()
    }

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
            cell.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(updateData.tradingPrice)"
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "* 수량"
            giveColotString(label: cell.nameLabel, colorStr: "*", color: .systemRed)
            
            cell.selectionStyle = .none
            cell.amountTextField.tag = 1
            cell.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(updateData.tradingAmount)"
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
        
        if indexPath.section == 0 {
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
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        guard let result = sender.text else { return }
        
        switch self.addOrEditAction {
        case .write:
            switch sender.tag {
            case 0:
                self.diaryData.tradingPrice = Int(result) ?? 0
            case 1:
                self.diaryData.tradingAmount = Int(result) ?? 0
            default:
                break
            }
        case .edit:
            switch sender.tag {
            case 0:
                self.updateData.tradingPrice = Int(result) ?? 0
            case 1:
                self.updateData.tradingAmount = Int(result) ?? 0
            default:
                break
            }
        }
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
        case .write:
                self.diaryData.tradingMemo = textView.text
        case .edit:
            self.updateData.tradingMemo = textView.text
        }
        
        if textView.text.count > 300 {
            textView.deleteBackward()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == Constants.Word.trdDryMemoPlchdr.rawValue {
            textView.textColor = .subTextColor
            textView.text = Constants.Word.trdDryMemoPlchdr.rawValue
        }
        
        switch addOrEditAction {
        case .write:
                self.diaryData.tradingMemo = textView.text
        case .edit:
            self.updateData.tradingMemo = textView.text
        }
    }
    
}


// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    @objc func doneButtonTapped() {
        
        switch addOrEditAction {
        case .write:
            if diaryData.corpName == "매매한 종목 검색하기" || diaryData.tradingPrice == 0 || diaryData.tradingAmount == 0 {
                self.showAlertMessage(title: "필수 입력 항목을 모두 채워주세요.")
                return
            } else {
                diaryData.regDate = Date()
//                TradingDiaryRepository.standard.plusDiary(item: diaryData)
                CorpRegisterRepository.standard.plusDiaryatList(item: diaryData)
                navigationController?.popViewController(animated: true)
            }
        case .edit:
            if updateData.corpName == "매매한 종목 검색하기" || updateData.tradingPrice == 0 || updateData.tradingAmount == 0 {
                self.showAlertMessage(title: "필수 입력 항목을 모두 채워주세요.")
                return
            } else {
                updateData.regDate = Date()
                TradingDiaryRepository.standard.update(oldItem: diaryData, newItem: updateData)
                
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
    func sendData(_ vc: UIViewController, Input value: String, formalName: String, dartCode: String) {
        
        print("매매일지로 넘어옴 : \(value), \(formalName), \(dartCode) 선택")
        
        switch addOrEditAction {
        case .write: self.diaryData.corpName = value
        case .edit: self.updateData.corpName = value
        }

        self.mainView.tableView.reloadData()
    }
    
}








