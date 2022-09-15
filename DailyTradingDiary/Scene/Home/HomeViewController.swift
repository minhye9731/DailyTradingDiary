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
//        mainView.tableView.delegate = self
//        mainView.tableView.dataSource = self
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

