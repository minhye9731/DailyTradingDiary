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
        
        let alphaKey = [APIKey.ALPHA_KEY_1, APIKey.ALPHA_KEY_2, APIKey.ALPHA_KEY_3, APIKey.ALPHA_KEY_4].randomElement()!
        
        let url = type.requestURL + "&apikey=\(alphaKey)"
        print("news에 사용된 alpha key : \(alphaKey)")
        
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
    
}







