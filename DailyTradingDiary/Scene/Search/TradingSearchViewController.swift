////
////  TradingSearchViewController.swift
////  DailyTradingDiary
////
////  Created by 강민혜 on 9/16/22.
////
//
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
//
//protocol SendDataDelegate {
//    func sendData(_ vc: UIViewController, Input value: String)
//}
//
class TradingSearchViewController: BaseViewController {
    
    let mainView = TradingSearchView()
    var RegisterOrTrading: SearchMode = .registerCorp
    
    //    var delegate: SendDataDelegate?
    
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
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.tableView.keyboardDismissMode = .onDrag
        self.searchController.searchBar.resignFirstResponder()
        
        fetchData()
        isEmptyCheck()
        self.mainView.tableView.reloadData()
    }
    
    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        setNav()
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
        
        switch RegisterOrTrading {
        case .registerCorp: CorpCodeRepository.standard.filteredRegisterMode(searchText: searchText)
            isEmptyCheck()
            self.mainView.tableView.reloadData()
        case .tradingDiary: CorpCodeRepository.standard.filteredTradingMode(searchText: searchText)
            isEmptyCheck()
            self.mainView.tableView.reloadData()
        }
        
//        DispatchQueue.main.async { self.mainView.tableView.reloadData() }
//        self.mainView.tableView.reloadData()
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
        print(#function)
        return self.isFiltering ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.isFiltering ? CorpCodeRepository.standard.tasks.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print(#function)
        guard let customHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
        
        customHeaderView.sectionTitleLabel.text = "검색결과 \(CorpCodeRepository.standard.tasks.count)건"
        customHeaderView.giveColorString(label: customHeaderView.sectionTitleLabel, colorStr: "\(CorpCodeRepository.standard.tasks.count)")
        
        return customHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedStockTableViewCell.reuseIdentifier) as? SearchedStockTableViewCell else { return UITableViewCell() }
        
        cell.setData(arr: Array(CorpCodeRepository.standard.tasks), indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        //
        //        let selectedCorpName = filteredArray[indexPath.row].itemName
        print("눌렸다")
        //        delegate?.sendData(self, Input: selectedCorpName)
        //        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("취소버튼 눌림")
        self.dismiss(animated: true)
    }
    
    func fetchData() {
        switch RegisterOrTrading {
        case .registerCorp: CorpCodeRepository.standard.fetchRealmRegisterMode()
        case .tradingDiary: CorpCodeRepository.standard.fetchRealmTradingMode()
        }
    }
    
    func isEmptyCheck() {
        if !self.isFiltering {
            self.mainView.tableView.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else if CorpCodeRepository.standard.tasks.count == 0 {
            self.mainView.tableView.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            print("tasks개수가 0개가 아니다! - \(CorpCodeRepository.standard.tasks.count)개")
            self.mainView.tableView.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }
    
    
    
    
}
