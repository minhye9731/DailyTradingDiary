//
//  NewsTableViewCell.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/19/22.
//

import UIKit
import Kingfisher

final class NewsTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Iconic Sports Carmaker Porsche Will Go Public on September 29" // test
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022.09.19" // test
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "The Street" // test
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    let topicLabel: UILabel = {
        let label = UILabel()
        label.text = " Economy - Monetary " // test
        label.textColor = .subTextColorReverse
        label.backgroundColor = .subTextColor
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .left
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.text = " TSLA " // test
        label.textColor = .subTextColorReverse
        label.backgroundColor = .subTextColor
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .left
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 6
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        
        let url = URL(string: "https://www.thestreet.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cg_faces:center%2Cq_auto:good%2Cw_620/MTg1Mzk2NDQ1ODI0Njg5NDQz/xpeng-smart-suv-g9.jpg")
        imageview.kf.setImage(with: url)
        
        return imageview
    }()
    
    override func configure() {
        [titleLabel, releaseDateLabel, sourceLabel, topicLabel, tickerLabel, profileImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-24)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(84)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.leading.equalTo(releaseDateLabel.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(12)
        }
        
        tickerLabel.snp.makeConstraints { make in
            make.leading.equalTo(topicLabel.snp.trailing).offset(8)
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(12)
        }
        
    }
    
}
