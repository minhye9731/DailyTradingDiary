//
//  ALPHAAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import Network

class ALPHAAPIManager {
    static let shared = ALPHAAPIManager()
    
    private init() { }
    
    // 뉴스
    func fetchAlphaNewsAPI(type: Endpoint, completionHandler: @escaping(NetworkResult<Any>) -> ()) {
        
        let url = type.requestURL + "&apikey=\(APIKey.ALPHA_KEY_1)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<500).responseData { response in
            switch response.result {
            case .success:
                
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                
                completionHandler(networkResult)

            case .failure:
                completionHandler(.pathErr)
            }
        }
    }
    
    // statusCode별 처리를 나눠줌
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isValidData(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(AlphaMarketNewsResponse.self, from: data) else { return .pathErr }
        return .success(decodedData.feed)
    }
    
    
    
    // 원달러 환율
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
    
    // 미국채 10년물
    func fetchAlphaTYAPI(type: Endpoint) {
        // , completionHandler: @escaping(String, String) -> ()
        let url = type.requestURL + "&interval=daily&maturity=10year&apikey=\(APIKey.ALPHA_KEY_2)"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                let data = json["data"].arrayValue
                
                
//                completionHandler(dDayData, dDayBeforeData)

            case .failure(let error):
                print(error)
            }
        }
    }
    
}







