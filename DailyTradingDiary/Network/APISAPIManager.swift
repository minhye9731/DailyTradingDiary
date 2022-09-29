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

class APISAPIManager {
    static let shared = APISAPIManager()
    private init() { }
    
//    func fetchKRXItemAPI(type: Endpoint, baseDate: String, searchText: String, completionHandler: @escaping(NetworkResult<Any>) -> ()) {
//        
//        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//        
//        let url = type.requestURL + "serviceKey=\(APIKey.APIS_KEY)&likeItmsNm=\(searchText)&resultType=json&basDt=\(baseDate)"
//        
//        AF.request(url, method: .get).validate(statusCode: 200..<500).responseData { response in
//            switch response.result {
//            case .success:
//                
//                guard let statusCode = response.response?.statusCode else { return }
//                guard let value = response.value else { return }
//                let networkResult = self.judgeStatus(by: statusCode, value)
//                
//                completionHandler(networkResult)
//                
//            case .failure:
//                completionHandler(.pathErr)
//            }
//        }
//    }

    func fetchApisStockAPI(type: Endpoint, baseDate: String, clickText: String, completionHandler: @escaping(NetworkResult<Any>) -> ()) {
        
        guard let clickedText = clickText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + "serviceKey=\(APIKey.APIS_KEY)&numOfRows=10&pageNo=1&itmsNm=\(clickedText)&resultType=json&basDt=\(baseDate)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<500).responseData { response in
            switch response.result {
            case .success:
                
                guard let statusCode = response.response?.statusCode else { return }
                print("statusCode: \(statusCode)")
                guard let value = response.value else { return }
                let networkResult = self.judgeStatusCode(by: statusCode, value)
                
                completionHandler(networkResult)
                
            case .failure:
                completionHandler(.pathErr)
            }
        }
    }
    
    // 상장정보 한글명
//    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
//        switch statusCode {
//        case 200: return isValidData(data: data)
//        case 400: return .pathErr
//        case 500: return .serverErr
//        default: return .networkFail
//        }
//    }
//
//    private func isValidData(data: Data) -> NetworkResult<Any> {
//
//        let decoder = JSONDecoder()
//        guard let decodedData = try? decoder.decode(KRXListResponse.self, from: data) else { return .pathErr }
//        return .success(decodedData.response.body.items.item)
//    }
    
    // 주식 시세정보
    private func judgeStatusCode(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isValidResult(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isValidResult(data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(APISStockInfoResponse.self, from: data) else { return .pathErr }
        dump("decodedData: \(decodedData)")
        return .success(decodedData.response.body.items.item)
    }
    
}
