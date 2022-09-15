//
//  HomeViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import FSCalendar

final class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    let mainView = HomeView()
    var selectedDate: Date = Date()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        self.view.backgroundColor = .backgroundColor

        
    }
    
    override func configure() {
        print(#function)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.calendar.dataSource = self
        mainView.calendar.delegate = self
        setNav()
        setSearchController()
        setCalendarUI()
    }

    func setNav() {
        // 아니면 아예 제목용 라벨 커스텀으로 저장해도 좋을 듯
        let titleLabel = UILabel()
        titleLabel.text = "Trading Diary"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .pointColor
        titleLabel.font = .systemFont(ofSize: 27, weight: .bold)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        self.navigationController?.navigationBar.tintColor = .pointColor
        
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "작성한 매매일지의 키워드를 검색해보세요! :)"
        searchController.searchBar.showsScopeBar = false
        self.navigationItem.searchController = searchController
    }
    


    
}


// MARK: - tableview 설정
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return realm에 업데이트된 데이터 배열의 수
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tradeCell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.reuseIdentifier) as? TradeTableViewCell else { return UITableViewCell() }
        
        guard let analysisCell = tableView.dequeueReusableCell(withIdentifier: AnalysisTableViewCell.reuseIdentifier) as? AnalysisTableViewCell else { return UITableViewCell() }
        
        // 임시 test. 메모작성 완료하고나면 tag값에 따라 cell 종류 구분 예정
        
        if indexPath.section < 3 {
            // 이거 묶어서 setTradeData 함수로 묶자
            tradeCell.nameLabel.text = "MSFT" // test
            tradeCell.amountLabel.text = "2 주" // test
            tradeCell.isTradingLabel.text = "매수" // test - 매수/매도값에 따라서 구분 필요
            tradeCell.priceLabel.text = "(매수단가 : $251.44 )" // test
            return tradeCell
        }
        
        analysisCell.nameLabel.text = "삼성전자" // test
        analysisCell.buyExpectPriceLabel.text = "55,000 원"
        analysisCell.buyExpectDateLabel.text = "2022.09.21"
        analysisCell.sellExpectPriceLabel.text = "63,000 원"
        analysisCell.sellExpectDateLabel.text = "2022.09.28"
        
        return analysisCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 째 셀을 클릭했습니다. 해당 생성파일의 보기으로 넘어감")
        
//        let tradeDiaryVC = 매매일지 뷰컨()
//        let corpAnalysisVC = 기업분석 뷰컨()
        
//        만약 매매일지/기업분석 tag값으로 구분을 해서 각 해당하는 화면으로 넘어가기
//        이 때 데이터도 넘겨주자
        
//        transition()
        
    }
    
    // 오른쪽에서 스와이프시 삭제
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        print(#function)
//
//        let row = self.filteredArray[indexPath.row]
//
//        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completion in
//
//            self.deleteConfirmAlert(title: "해당 메모를 삭제하시겠습니까?") { _ in
//
//                self.repository.deleteItem(item: row)
//                self.fetchSortRealm(sort: "memoDate")
//            }
//        }
//        delete.image = UIImage(systemName: Constants.ImageName.trash.rawValue)
//        delete.backgroundColor = .deleteColor
//
//        return UISwipeActionsConfiguration(actions: [delete])
//
//    }
    
}




// MARK: - FSCalendar 설정
extension HomeViewController: FSCalendarDelegateAppearance {
    
    // 변경이 필요할 때 별도설정 해야함
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { (make) in
//            make.height.equalTo(bounds.height)
//            // Do other updates
//        }
//        self.view.layoutIfNeeded()
//    }
    
    // 오늘 날짜로 돌아오는 액션 추가
    
    func setCalendarUI() {
        // 다국어 설정시 각 하드코딩 요소들 constants로 구분필요
        self.mainView.calendar.locale = Locale(identifier: "ko_KR")
        
        self.mainView.calendar.placeholderType = .fillHeadTail
        
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // 요일
        self.mainView.calendar.appearance.weekdayFont = .systemFont(ofSize: 14, weight: .regular) // 요일 글자
        self.mainView.calendar.appearance.weekdayTextColor = .mainTextColor
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed // 적용안됨
        self.mainView.calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue // 적용안됨
        
        self.mainView.calendar.appearance.titleFont = .systemFont(ofSize: 14, weight: .regular) // 숫자 글자
        
        self.mainView.calendar.scrollEnabled = true
        self.mainView.calendar.scrollDirection = .horizontal
        
        self.mainView.calendar.appearance.headerDateFormat = "YYYY MM월"
        self.mainView.calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .regular)
        self.mainView.calendar.appearance.headerTitleColor = .mainTextColor
        self.mainView.calendar.appearance.headerTitleAlignment = .center
        
        // 일자
        self.mainView.calendar.appearance.titlePlaceholderColor = .subTextColor // 유효하지 않은 날
        self.mainView.calendar.appearance.titleDefaultColor = .mainTextColor // 평일
//        self.mainView.calendar.appearance.title // 일요일은 빨간색
        // 토요일은 파란색

        // today
        self.mainView.calendar.appearance.titleTodayColor = .mainTextColor
        self.mainView.calendar.appearance.todayColor = .subTextColor
        
        // 선택일
        self.mainView.calendar.select(selectedDate)
        self.mainView.calendar.appearance.selectionColor = .pointColor
        self.mainView.calendar.appearance.titleSelectionColor = .mainTextColor
    }
    
    // 날짜 선택시 발생하는 일
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 해당 날짜에 작성한 매매일지&기업분석을 tableview에 보여주기
        print("해당 날짜에 작성한 매매일지&기업분석을 tableview에 보여주기")
    }
    
    // 선택된 날짜의 채워진 색상 지정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return appearance.selectionColor
    }
    
    // event 설정
    
    
}

