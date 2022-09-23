//
//  TradingDiaryViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/15/22.
//

import UIKit
import SnapKit
import RealmSwift

final class TradingDiaryViewController: BaseViewController {

    let mainView = TradingDiaryView()
    
    // api로 받는 데이터 model
    var krxData: KRXModel = KRXModel(itemName: "-", corpName: "-", marketName: "-", srtnCode: "-", isinCode: "-")
    
    // realm으로 저장할 데이터 model
    var diaryData: TradingDiary = TradingDiary(corpName: "", corpCode: "", tradingPrice: 0, tradingAmount: 0, regDate: Date(), tradingDate: Date(), tradingMemo: "")
    
    var addOrEditAction: PageMode = .write
    
    // MARK: - lifecycle
    override func loadView() {
        self.view = mainView
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
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
            
            cell.corpNameTextField.tag = 0
            cell.corpNameTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.corpNameTextField.text = diaryData.corpName
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "* 매매단가"
            giveColotString(label: cell.nameLabel, colorStr: "*")
            
            cell.selectionStyle = .none
            cell.amountTextField.tag = 1
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(diaryData.tradingPrice)"
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = "* 수량"
            giveColotString(label: cell.nameLabel, colorStr: "*")
            
            cell.selectionStyle = .none
            cell.amountTextField.tag = 2
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(diaryData.tradingAmount)"
            }
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySellTableViewCell.reuseIdentifier) as? BuySellTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.segmentControl.tag = 5
            
            // 표기용
            if addOrEditAction == .edit {
                cell.segmentControl.selectedSegmentIndex = diaryData.buyAndSell ? 1 : 0
            }
            
            // 저장/수정용
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
                    case 0: TradingDiaryRepository.standard.buyAndSellUpdate(oldItem: self.diaryData, newItem: false)
                    case 1:
                        TradingDiaryRepository.standard.buyAndSellUpdate(oldItem: self.diaryData, newItem: true)
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
                    cell.memoTextView.text = diaryData.tradingMemo
                    cell.memoTextView.textColor = .mainTextColor
                }
                cell.memoTextView.text = Constants.Word.trdDryMemoPlchdr.rawValue
                cell.memoTextView.textColor = .subTextColor
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
    
}

// MARK: - textfield delegate
extension TradingDiaryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch self.addOrEditAction {
        case .write:
            switch textField.tag {
            case 0:
                self.diaryData.corpName = textField.text ?? "(기업명)"
                self.diaryData.corpCode = "00000" // 임시데이터
            case 1:
                self.diaryData.tradingPrice = Int(textField.text ?? "0") ?? 0
            case 2:
                self.diaryData.tradingAmount = Int(textField.text ?? "0") ?? 0
            default:
                break
            }
        case .edit:
            switch textField.tag {
            case 0:
                TradingDiaryRepository.standard.corpNameUpdate(oldItem: diaryData, newItem: textField.text ?? "(기업명)")
            case 1:
                TradingDiaryRepository.standard.tradingPriceUpdate(oldItem: diaryData, newItem: Int(textField.text ?? "0") ?? 0)
            case 2:
                TradingDiaryRepository.standard.tradingAmountUpdate(oldItem: diaryData, newItem: Int(textField.text ?? "0") ?? 0)
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
            TradingDiaryRepository.standard.tradingMemoUpdate(oldItem: diaryData, newItem: textView.text)
        }
    }
    
}


// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    @objc func doneButtonTapped() {
        if diaryData.corpName.isEmpty || diaryData.tradingPrice == 0 || diaryData.tradingAmount == 0 {
            self.showAlertMessage(title: "필수 입력 항목을 모두 채워주세요.")
            return
        }
        plusOrUpate(task: diaryData)
        navigationController?.popViewController(animated: true)
    }
    
    func plusOrUpate(task: TradingDiary) {
        switch addOrEditAction {
        case .write:
            task.regDate = Date()
            TradingDiaryRepository.standard.plusDiary(item: task)
        case .edit:
            TradingDiaryRepository.standard.regDateUpdate(oldItem: task, newItem: Date())
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
            TradingDiaryRepository.standard.tradingDateUpdate(oldItem: diaryData, newItem: sender.date)
        }
    }
    
    
}








