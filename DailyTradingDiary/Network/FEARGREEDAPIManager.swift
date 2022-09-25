//
//  FEARGREEDAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class FEARGREEDAPIManager {
    static let shared = FEARGREEDAPIManager()
    
    private init() { }
    
    func fetchFearGreedAPI(completionHandler: @escaping(FearGreedData) -> ()) {
        
        let url = URL.fearGreedURL
        
        let header: HTTPHeaders = [
            "X-RapidAPI-Key": "\(APIKey.FEAR_GREED_KEY)",
            "X-RapidAPI-Host": "fear-and-greed-index.p.rapidapi.com"
        ]
        
        AF.request(url, method: .get, headers: header).responseData { response in
            switch response.result {
            case .success(let value):
                print("탐욕공포지수 api 연결 성공이다")
                
                
                let json = JSON(value)
                
                let updateTime = json["lastUpdated"]["humanDate"].stringValue
                print("updateTime : \(updateTime)")
                
                let nowValue = json["fgi"]["now"]["value"].intValue
                let nowStatus = json["fgi"]["now"]["valueText"].stringValue
                
                let weekAgoValue = json["fgi"]["oneWeekAgo"]["value"].intValue
                let weekAgoStatus = json["fgi"]["oneWeekAgo"]["valueText"].stringValue
                
                let nowResult = FearGreed(indexValue: nowValue, indexStatus: nowStatus)
                let weekAgoResult = FearGreed(indexValue: weekAgoValue, indexStatus: weekAgoStatus)
                
                let fearGreedIndex = FearGreedData(updateTime: updateTime, now: nowResult, weekAgo: weekAgoResult)
                
                completionHandler(fearGreedIndex)
                
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
}
