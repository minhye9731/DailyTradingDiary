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
        
        let url = type.requestURL + "&apikey=\(APIKey.ALPHA_KEY_1)"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let newsData = json["feed"].arrayValue
                
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
                completionHandler(newsDataArray)

            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchAlphaFXAPI(type: Endpoint, from: String, to: String, completionHandler: @escaping(String, String) -> ()) {
        let url = type.requestURL + "&from_symbol=\(from)&to_symbol=\(to)&interval=5min&apikey=\(APIKey.ALPHA_KEY_2)"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let lastRefreshed = json["Meta Data"]["5. Last Refreshed"].stringValue
                let latestDay = String(lastRefreshed.prefix(10)) // 2022-09-23
                
                let latestDayDateform = latestDay.toDateinUTC()
                guard let beforeLatestDay = Calendar.current.date(byAdding: .day, value: -1, to: latestDayDateform ?? Date())?.toStringinUTC() else { return } // 2022-09-22
                
                let numberFormatter = NumberFormatter()
                numberFormatter.maximumFractionDigits = 2
                
                let dDayData = json["Time Series FX (Daily)"]["\(latestDay)"]["4. close"].stringValue // 1421.26000
                let dDayBeforeData = json["Time Series FX (Daily)"]["\(beforeLatestDay)"]["4. close"].stringValue // 1406.22000
                
                completionHandler(dDayData, dDayBeforeData)

            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}







