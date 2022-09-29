//
//  DARTAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation
import Alamofire
import SwiftyJSON



class DARTAPIManager {
    static let shared = DARTAPIManager()
    
    private init() { }
    
    // 고유번호
    
    // 재무제표
    
    
    
    // MARK: - 배당
    func fetchDividendAPI(type: Endpoint, dartCropCode: String, year: String, completionHandler: @escaping(DartDividendModel) -> ()) {
        
        let fullurl = "https://opendart.fss.or.kr/api/alotMatter.json?crtfc_key=ca813c8b10a246d2c6b722caeb58f99dffb20870&corp_code=00126380&bsns_year=2021&reprt_code=11011"
        
        AF.request(fullurl,
                   method: .get).responseData { response in
            switch response.result {
            case .success(let value):
 
                let json = JSON(value)

                let stockData = json["list"].arrayValue

                let dps_one_bf = stockData[11]["thstrm"].stringValue
                let dps_two_bf = stockData[11]["frmtrm"].stringValue
                let dps_three_bf = stockData[11]["lwfr"].stringValue
                
                let payoutRatio_one_bf = stockData[6]["thstrm"].stringValue
                let payoutRatio_two_bf = stockData[6]["frmtrm"].stringValue
                let payoutRatio_three_bf = stockData[6]["lwfr"].stringValue
                
                let dividendInfo = DartDividendModel(dps_1yr_bf: dps_one_bf, dps_2yr_bf: dps_two_bf, dps_3yr_bf: dps_three_bf, dividend_payout_ratio_1yr_bf: payoutRatio_one_bf, dividend_payout_ratio_2yr_bf: payoutRatio_two_bf, dividend_payout_ratio_3yr_bf: payoutRatio_three_bf)
                
                completionHandler(dividendInfo)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}











