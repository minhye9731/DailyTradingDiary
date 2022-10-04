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
        label.textColor = .mainTextColor
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    let topicLabel: UILabel = {
        let label = UILabel()
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
    
    func setData(data: [MarketNewsDTO], indexPath: IndexPath) {
        
        print("newsCell의 setData 실행이다~!")
        
        let row = data[indexPath.row]
        
        self.titleLabel.text = row.title
        self.releaseDateLabel.text = row.publishedDate
        self.sourceLabel.text = row.source
        
        if row.topic.isEmpty {
            self.topicLabel.text = " - "
        } else {
            self.topicLabel.text = " \(row.topic[0].topic) "
        }
        
        if row.relatedTicker.isEmpty {
            self.tickerLabel.text = " - "
        } else {
            self.tickerLabel.text = " \(row.relatedTicker[0].ticker) "
        }
        
        let url = URL(string: row.profileImageUrl)
        self.profileImageView.kf.indicatorType = .activity
        self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "newsPlaceholder.png") )
    }
    
}
