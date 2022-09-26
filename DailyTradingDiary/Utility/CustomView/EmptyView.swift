//
//  EmptyView.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/25/22.
//

import UIKit

class EmptyView: BaseView {
    
    func setDataAtEmptyView(image: String, main: String, sub: String) {
        emptyimage.image = UIImage(named: image)
        emptyNoticeMainLabel.text = main
        emptyNoticeSubLabel.text = sub
    }

    let emptyimage: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let emptyNoticeMainLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let emptyNoticeSubLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func configureUI() {
        [emptyimage, emptyNoticeMainLabel, emptyNoticeSubLabel].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .backgroundColor
    }
    
    override func setConstraints() {
        emptyNoticeMainLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyimage.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(emptyNoticeMainLabel.snp.top).offset(-16)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.1)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.15)
        }
        
        emptyNoticeSubLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(emptyNoticeMainLabel.snp.bottom).offset(6)
        }
    }
}
