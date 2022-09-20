//
//  ALPHAAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class ALPHAAPIManager {
    static let shared = ALPHAAPIManager()
    
    private init() { }
    
    func fetchAlphaNewsAPI(type: Endpoint, completionHandler: @escaping([MarketNewsModel]) -> ()) {
        
        let url = type.requestURL + "&apikey=\(APIKey.ALPHA_KEY_2)"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                print("성공이다")
                
                let json = JSON(value)
                
                let newsData = json["feed"].arrayValue
                
                print("\(newsData.count)")
                
                let newsDataArray: [MarketNewsModel] = newsData.map { news -> MarketNewsModel in
                    
                    let title = news["title"].stringValue
                    let url = news["url"].stringValue
                    let date = news["time_published"].stringValue
                    
                    let imageUrl = news["banner_image"].string ?? ""
                    let source = news["source"].stringValue
                    let topic = news["topics"][0]["topic"].stringValue
                    let relatedCorp = news["ticker_sentiment"][0]["ticker"].stringValue
                    
                    return MarketNewsModel(title: title, url: url, publishedDate: date, profileImageUrl: imageUrl, source: source, topic: topic, relatedTicker: relatedCorp)
                }
                
                print("newsDataArray : \(newsDataArray.count)")
                dump(newsDataArray[0])
                
                completionHandler(newsDataArray)

            case .failure(let error):
                print(error)
            }
        }
    }
    
}







