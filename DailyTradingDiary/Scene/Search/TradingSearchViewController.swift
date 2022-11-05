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

protocol SendDataDelegate {
    func sendData(_ vc: UIViewController, Input value: String, formalName: String, dartCode: String, srtnCode: String)
}

class TradingSearchViewController: BaseViewController {

    let mainView = TradingSearchView()
    var RegisterOrTrading: SearchMode = .registerCorp
    
    var filteredArray: [KRXListDTO] = []
    var registeredCorpArr: [String] = []
    var delegate: SendDataDelegate?

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
        self.mainView.backgroundColor = .backgroundColor
        isEmptyCheck()
        self.mainView.tableView.reloadData()
        self.mainView.tableView.keyboardDismissMode = .onDrag
        self.searchController.searchBar.resignFirstResponder()
        
        print("검색화면의 이번 페이지 모드 ===== \(self.RegisterOrTrading)")
    }

    override func configure() {
        self.mainView.tableView.delegate = self
        self.mainView.tableView.dataSource = self
        setNav()
        setEmptyViewWords()
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
        self.registeredCorpArr = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).map { return $0.corpName }
        
        // 일자관련 함수 설정하기
        APISAPIManager.shared.fetchKRXItemAPI(type: .krxItemInfo, baseDate: "20220928", searchText: searchText) { searchedCropArr in
            
            switch self.RegisterOrTrading {
            case .registerCorp: self.filteredArray = searchedCropArr
            case .tradingDiary: self.filteredArray = searchedCropArr.filter {
                self.registeredCorpArr.contains($0.itemName)
            }
            }
            
            DispatchQueue.main.async {
                self.isEmptyCheck()
                self.mainView.tableView.reloadData()
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
        cell.setData(arr: filteredArray, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let startTime = CFAbsoluteTimeGetCurrent()
            let generalName = self.filteredArray[indexPath.row].itemName // 삼성전자
            let formalName = self.filteredArray[indexPath.row].corpName // 삼성전자(주)
            
            let srtnCode = String(self.filteredArray[indexPath.row].srtnCode.dropFirst())
            
            let selectedCorpCode = CorpCodeRepository.standard.filterSelectedCrop(srtnCd: srtnCode)
            
            self.delegate?.sendData(self, Input: generalName, formalName: formalName, dartCode: selectedCorpCode, srtnCode: srtnCode) // 여기서 realm threading 에러발생
            
            print("선택기업의 정보 -> 기업등록 화면으로 전달 완료 📩: \(CFAbsoluteTimeGetCurrent() - startTime)")
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
    
    func setEmptyViewWords() {
        switch RegisterOrTrading {
        case .registerCorp :
            self.mainView.emptyView.setDataAtEmptyView(image: "accountingBook.png", main: "조회하신 조건에 해당하는 기업정보가 없어요.", sub: "관심기업으로 등록할 기업의 한글명이나 종목코드를 검색해보세요.")
        case .tradingDiary :
            self.mainView.emptyView.setDataAtEmptyView(image: "accountingBook.png", main: "조회하신 기업은 관심기업에 미등록된 상태입니다.", sub: "관심기업으로 등록한 이후 매매일지를 작성해주세요.")
        }
    }
    
    func isEmptyCheck() {
        if filteredArray.count == 0 {
            self.mainView.tableView.isHidden = true
            self.mainView.emptyView.isHidden = false
        } else {
            self.mainView.tableView.isHidden = false
            self.mainView.emptyView.isHidden = true
        }
    }

}
