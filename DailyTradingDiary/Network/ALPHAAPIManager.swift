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
                guard let value = response.value else { return } // 결과데이터를 바로 뷰컨으로 보내지 않고, 상태코드별 판단을 거치고 가공을 한 후에 보낸다.
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
        case 200: return isValidData(data: data) // 연결 성공시 데이터를 가공해서 전달해줘야 하기 때문에 별도 함수로 넘긴다
        case 400: return .pathErr // 잘못된 요청
        case 500: return .serverErr
        default: return .networkFail // 기타 등등 에러들은 모두 네트워크 에러로 분기처리 예정
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







