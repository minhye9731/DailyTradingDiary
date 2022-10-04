//
//  KRXAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import Network
import Toast

// MARK: - 공공데이터 api 통신

class APISAPIManager {
    static let shared = APISAPIManager()
    private init() { }
    
    
     // MARK: - search 뷰컨의 상장종목 검색용
    func fetchKRXItemAPI(type: Endpoint, baseDate: String, searchText: String, completionHandler: @escaping([KRXListDTO]) -> ()) {
        
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + "serviceKey=\(APIKey.APIS_KEY)&likeItmsNm=\(searchText)&resultType=json&basDt=20220928"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                
                print("search 통신은 성공")
                let json = JSON(value)
                
                let data = json["response"]["body"]["items"]["item"].arrayValue
                print(data)

                let searchedCropArr: [KRXListDTO] = data.map { item -> KRXListDTO in
                    let name = item["itmsNm"].stringValue // 검색 연결용
                    let corpName = item["corpNm"].stringValue // 공식적인 이름 (주)
                    let market = item["mrktCtg"].stringValue
                    let srtnCd = item["srtnCd"].stringValue
                    let isinCd = item["isinCd"].stringValue

                    return KRXListDTO(itemName: name, corpName: corpName, marketName: market, srtnCode: srtnCd, isinCode: isinCd)
                }
                
                print("KRX 상장종목 검색결과 - \(searchedCropArr)")
                completionHandler(searchedCropArr)
                
            case .failure(let error):
                print("search 통신은 실패: \(error)")
            }
        }
    }

    // MARK: - '기업등록'페이지내 summary에 들어갈 종목 summary 데이터 통신용
    func fetchApisStockAPI(type: Endpoint, clickText: String, completionHandler: @escaping(NetworkResult<Any>) -> ()) {
        
        guard let clickedText = clickText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + "serviceKey=\(APIKey.APIS_KEY)&numOfRows=10&pageNo=1&itmsNm=\(clickedText)&resultType=json&basDt=20220928"
        
        AF.request(url, method: .get).validate(statusCode: 200..<500).responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else { return }
                let networkResult = self.judgeStatusCode(by: statusCode, value)
                completionHandler(networkResult)
            case .failure:
                completionHandler(.pathErr)
            }
        }
    }
    
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
        return .success(decodedData.response.body.items.item)
    }
    
}
