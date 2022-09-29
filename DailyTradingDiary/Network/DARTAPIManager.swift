//
//  DARTAPIManager.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/29/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import Zip
import SWXMLHash
import RealmSwift

class DARTAPIManager {
    static let shared = DARTAPIManager()
    
    private init() { }
    
    // 고유번호
    func downloadCorpCode(type: Endpoint) {
        
        let url = type.requestURL
        let parameter = ["crtfc_key": "\(APIKey.DART_KEY)"]
        
        let fileManager = FileManager.default
        let documentDirectoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName: String = URL(string: url)!.lastPathComponent.replacingOccurrences(of: ".xml", with: ".zip")
        let fileURL = documentDirectoryPath.appendingPathComponent(fileName)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        AF.download(url, method: .get, parameters: parameter, to: destination).response { response in
            switch response.result {
            case .success(let response):
                
                guard let baseURL = response else { return }
                guard let path = self.documentDirectoryPath() else {
                    print("도큐먼트 위치에 오류가 있습니다.")
                    return
                }
                
                let sandboxFileURL = path.appendingPathComponent(baseURL.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
                    
                    let newfileURL = documentDirectoryPath.appendingPathComponent("\(fileName)")
                    print(newfileURL)
                    
                    do {
                        try Zip.unzipFile(newfileURL, destination: documentDirectoryPath, overwrite: true, password: nil, progress: { progress in
                        }, fileOutputHandler: { unzippedFile in
                            print("unzippedFile(1): \(unzippedFile)")
                            
                            CorpCodeRepository.standard.deleteAllItem() // 일단 해당렘 전체삭제
                            self.getDataFromXmlFile() // 파싱 함수 호출
                            
                        })
                    } catch {
                        print("압축 해제에 실패했습니다.(1)")
                    }
                    
                } else {
                    // 2)
                    do {
                        // 파일 앱의 zip -> 도큐먼트 폴더에 복사
                        try FileManager.default.copyItem(at: baseURL, to: sandboxFileURL)
                        let fileURL = documentDirectoryPath.appendingPathComponent("\(fileName)")
                        try Zip.unzipFile(fileURL, destination: documentDirectoryPath, overwrite: true, password: nil, progress: { progress in
                            print("progress(2): \(progress)")
                        }, fileOutputHandler: { unzippedFile in
                            print("복구가 완료되었습니다. unzippedFile(2): \(unzippedFile)")
                        })
                        
                    } catch {
                        print("압축 해제에 실패했습니다.(2)")
                    }
                    print("압축 해제에 실패했습니다.(2)")
                }
            case .failure(let error):
                print("파일 다운로드 실패, \(error)")
            }
        }
    }
    
    // 파일경로
    func documentDirectoryPath() -> URL? {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectoryPath
    }

    // 파싱
    func getDataFromXmlFile() {
        
        let fileURL = documentDirectoryPath()?.appendingPathComponent("CORPCODE.xml")
        do {
            let data = try String(contentsOf: fileURL!, encoding: .utf8)
            print("xml 파일 내부의 raw값 rawDirectoryContents 가져오기 성공~")
            let xml = XMLHash.lazy(data)
            // 파싱한 값을 렘에 저장하자
            
            let listsArr: [List] = try xml["result"]["list"].value()
            print("listsArr 첫 번째 요소의 종목코드 빈 값: \(listsArr[0].stock_code)")
            
            let corpCodeArr: [CorpCodeRealmModel] = listsArr.map {
                let dartCd = $0.corp_code
                let name = $0.corp_name
                let stckCd = $0.stock_code
                let mDate = $0.modify_date
                
                return CorpCodeRealmModel(corpCode: dartCd, corpName: name, stockCode: stckCd, modifyDate: mDate)
            }
            print("corpCodeArr 첫 번째 요소: \(corpCodeArr[0])")
            
            CorpCodeRepository.standard.plusCorpCode(item: corpCodeArr)
            
        } catch {
            print("xml 파일 내부의 raw값 가져오기 실패!")
        }
    }
    
    // MARK: - 재무제표
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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











