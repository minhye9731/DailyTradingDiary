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

//protocol SendDataDelegate: AnyObject {
//    func sendData(data: KRXModel)
//}

class TradingSearchViewController: BaseViewController {
    
    var filteredArray: [KRXModel] = []
//    weak var delegate: SendDataDelegate?
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(SearchedStockTableViewCell.self, forCellReuseIdentifier: SearchedStockTableViewCell.reuseIdentifier)
        tableview.rowHeight = 50
        return tableview
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "기업명·종목코드를 검색해보세요!"
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
        navigationController?.navigationBar.barTintColor = .pointColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .pointColor
        
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        setBackButtonName(name: "")
    }


    
    
}


// MARK: - search 관련 설정
extension TradingSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        KRXAPIManager.shared.fetchKRXItemAPI(type: .krxItemInfo, baseDate: "20220914", searchText: searchText)
        
        // 네트워크 통신

        
        self.tableView.reloadData()
        
    }
    
    
}

extension TradingSearchViewController: UISearchBarDelegate {
    
}








// MARK: - tableview 설정
extension TradingSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isFiltering ? 1 : 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredArray.count : 0
    }
    
    // headerinsection xx개 찾음 적어주기

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedStockTableViewCell.reuseIdentifier) as? SearchedStockTableViewCell else { return UITableViewCell() }
        
        cell.setDataAtCell(arr: filteredArray, indexPath: indexPath)

//        cell.nameLabel.text = "CJ대한통운"
//        cell.marketLabel.text = "KOSPI"
//        cell.srtnCdLabel.text = "000120"
//        cell.isinCdLabel.text = "KR7000120006"

        cell.backgroundColor = .orange
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = filteredArray[indexPath.row]
//        self.delegate?.sendData(data: selectedData)
        self.navigationController?.popViewController(animated: true)
    }
    
    


}

// MARK: - searchbar 설정
//extension TradingSearchViewController: UISearchBarDelegate {
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("취소버튼 눌림")
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}

extension TradingSearchViewController {
    
    func setBackButtonName(name: String) {
        let backBarButtonItem = UIBarButtonItem(title: name, style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    
}
