//
//  TradingSearchViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

protocol SendDataDelegate {
    func sendData(_ vc: UIViewController, Input value: String)
}

class TradingSearchViewController: BaseViewController {
    
    var filteredArray: [KRXModel] = []
    var delegate: SendDataDelegate?
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(SearchedStockTableViewCell.self, forCellReuseIdentifier: SearchedStockTableViewCell.reuseIdentifier)
        tableview.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        tableview.rowHeight = 50
        return tableview
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .mainTextColor
        searchController.searchBar.placeholder = "기업명을 검색해보세요!"
        searchController.automaticallyShowsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        self.searchController.searchBar.resignFirstResponder()
    }

    override func configure() {
        setNav()
        self.view.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }

    func setNav() {
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
        
        navigationController?.navigationBar.barTintColor = .pointColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .pointColor
        navigationController?.navigationBar.backgroundColor = .backgroundColor
        
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

}


// MARK: - search 관련 설정
extension TradingSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        KRXAPIManager.shared.fetchKRXItemAPI(type: .krxItemInfo, baseDate: "20220923", searchText: "\(searchText)") { (response) in
            
            switch(response) {
            case .success(let searchedList):
                
                if let data = searchedList as? [Item] {
                    
                    let searchedCropArr: [KRXModel] = data.map { item -> KRXModel in
                        let name = item.itmsNm
                        let corpName = item.corpNm
                        let market = item.mrktCtg
                        let srtnCd = item.srtnCD
                        let isinCd = item.isinCD
                        
                        return KRXModel(itemName: name, corpName: corpName, marketName: market, srtnCode: srtnCd, isinCode: isinCd)
                    }
                    self.filteredArray = searchedCropArr
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
    
    
}

extension TradingSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


// MARK: - tableview 설정
extension TradingSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isFiltering ? 1 : 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }

        customHeaderView.sectionTitleLabel.text = "검색결과 \(filteredArray.count)건"
        customHeaderView.giveColorString(label: customHeaderView.sectionTitleLabel, colorStr: "\(filteredArray.count)")
        
        return customHeaderView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedStockTableViewCell.reuseIdentifier) as? SearchedStockTableViewCell else { return UITableViewCell() }
        cell.setDataAtCell(arr: filteredArray, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCorpName = filteredArray[indexPath.row].itemName
        print("눌렸다, \(selectedCorpName) 선택")
        delegate?.sendData(self, Input: selectedCorpName)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("취소버튼 눌림")
        self.dismiss(animated: true)
    }
    
}
