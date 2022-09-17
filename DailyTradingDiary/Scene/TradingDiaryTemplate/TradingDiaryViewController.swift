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
    let repository = DiaryRepository()
    
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
        navibarAppearance.backgroundColor = .subBackgroundColor
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
            print("cellForRowAt - 종목명 ")
            cell.selectionStyle = .none
            
            cell.corpNameTextField.tag = 0
            cell.corpNameTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.corpNameTextField.text = diaryData.corpName
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            print("cellForRowAt - 매매단가 ")
            cell.nameLabel.text = "매매단가"
            cell.selectionStyle = .none
            cell.amountTextField.tag = 1
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(diaryData.tradingPrice)"
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NumPriceTableViewCell.reuseIdentifier) as? NumPriceTableViewCell else { return UITableViewCell() }
            print("cellForRowAt - 수량 ")
            cell.nameLabel.text = "수량"
            cell.selectionStyle = .none
            cell.amountTextField.tag = 2
            cell.amountTextField.delegate = self
            
            if addOrEditAction == .edit {
                cell.amountTextField.text = "\(diaryData.tradingAmount)"
            }
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySellTableViewCell.reuseIdentifier) as? BuySellTableViewCell else { return UITableViewCell() }
            print("cellForRowAt - 매수매도 ")
            cell.selectionStyle = .none
            cell.segmentControl.tag = 5
            
            cell.segmentTapped = {
                switch cell.segmentControl.selectedSegmentIndex {
                case 0: self.diaryData.buyAndSell = false
                case 1: self.diaryData.buyAndSell = true
                default: break
                }
            }
            
            if addOrEditAction == .edit {
                cell.segmentControl.selectedSegmentIndex = diaryData.buyAndSell ? 1 : 0
            }
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeDateTableViewCell.reuseIdentifier) as? TradeDateTableViewCell else { return UITableViewCell() }
            print("cellForRowAt - 매매일자 ")
            cell.selectionStyle = .none
            cell.textField.tag = 3
            cell.textField.delegate = self
            
            if addOrEditAction == .edit {
                cell.textField.text = diaryData.tradingDate.toString()
            }
            
            return cell
        case 5:
            print("cellForRowAt - 메모 ")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.memoTextView.tag = 4
            cell.memoTextView.delegate = self
            
            if addOrEditAction == .edit {
                cell.memoTextView.text = diaryData.tradingMemo
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingMemoTableViewCell.reuseIdentifier) as? TradingMemoTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0...4: return 50
        case 5: return 300
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
        
        switch textField.tag {
        case 0:
            self.diaryData.corpName = textField.text ?? "(기업명)"
            self.diaryData.corpCode = "00000" // 임시 가라데이터 (수정예정)
        case 1:
            self.diaryData.tradingPrice = Int(textField.text ?? "0") ?? 0
        case 2:
            self.diaryData.tradingAmount = Int(textField.text ?? "0") ?? 0
        case 3:
            let inputDate = textField.text?.toDate()
            self.diaryData.tradingDate = inputDate ?? Date()
        default:
            print("textFieldDidEndEditing")
        }
    }
}

// MARK: - textview delegate
extension TradingDiaryViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 4 {
            self.diaryData.tradingMemo = textView.text ?? ""
        }
    }
    
    
}


// MARK: - 기타 함수들
extension TradingDiaryViewController {
    
    @objc func doneButtonTapped() {
        print("TradingDiaryView - \(#function)")
        
        switch addOrEditAction {
        case .write:
            self.diaryData.regDate = Date()
            repository.plusDiary(item: self.diaryData)
            navigationController?.popViewController(animated: true)
        case .edit:
            self.diaryData.regDate = Date()
            repository.update(oldItem: diaryData, newItem: diaryData)
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func plusOrUpate(task: TradingDiary) {
        switch addOrEditAction {
        case .write:
            repository.plusDiary(item: task)
        case .edit:
            repository.update(oldItem: diaryData, newItem: task)
        }
    }
    
    func setBackButtonName(name: String) {
        let backBarButtonItem = UIBarButtonItem(title: name, style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    
}








