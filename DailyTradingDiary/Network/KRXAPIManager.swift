//
//  KRXAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class KRXAPIManager {
    static let shared = KRXAPIManager()
    
    private init() { }
    
    func fetchKRXItemAPI(type: Endpoint, baseDate: String, searchText: String) {
        
        // completionHandler: @escaping([KRXModel] -> ())
        
//        let url = type.requestURL
        
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
//        let url = type.requestURL + "serviceKey=\(APIKey.KRX_KEY)&likeItmsNm=\(searchText)&resultType=json&basDt=\(baseDate)"
        
        let url = "https://apis.data.go.kr/1160100/service/GetKrxListedInfoService/getItemInfo?"
//
//        let parameter = [
//            "serviceKey": APIKey.KRX_KEY,
//            "resultType": "json",
//            "basDt": baseDate,
//            "likeItmsNm": searchText]
        
//        let fullurl = "https://apis.data.go.kr/1160100/service/GetKrxListedInfoService/getItemInfo?serviceKey=7kLeLTX%2FR3v%2FTqODZmmGVN1VVfj98v2o8I0EkFYhsJitTf2il0AklY30xLnujzHy%2FlQt%2BWwzHy1k9%2FvoQAmZjQ%3D%3D&likeItmsNm=%EB%91%90%EC%82%B0&resultType=json&basDt=20220914"
        
        AF.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                print("성공이다")
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
    
    
    
    
}
