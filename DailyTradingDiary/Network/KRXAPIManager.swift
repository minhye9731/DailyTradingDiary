//
//  KRXAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import Network

class KRXAPIManager {
    static let shared = KRXAPIManager()
    
    private init() { }
    
    func fetchKRXItemAPI(type: Endpoint, baseDate: String, searchText: String, completionHandler: @escaping(NetworkResult<Any>) -> ()) {
        
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + "serviceKey=\(APIKey.KRX_KEY)&likeItmsNm=\(searchText)&resultType=json&basDt=\(baseDate)"
        
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
        guard let decodedData = try? decoder.decode(KRXListResponse.self, from: data) else { return .pathErr }
        return .success(decodedData.response.body.items.item)
    }
    
    
    
    
    
}
