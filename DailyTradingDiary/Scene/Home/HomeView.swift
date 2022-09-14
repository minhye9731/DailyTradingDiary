//
//  HomeView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import SnapKit
import FSCalendar


final class HomeView: BaseView {
    
    var calendar: FSCalendar = {
        let calendar = FSCalendar()
        return calendar
    }()
    
    
    
    override func configureUI() {
        self.addSubview(calendar)
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(320)
            make.height.equalTo(300)
        }
        
    }
    

    
}









