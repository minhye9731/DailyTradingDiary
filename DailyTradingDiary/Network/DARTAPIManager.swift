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
    
    // MARK: - 고유번호
    
    func downloadCorpCode(type: Endpoint) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
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
                            print("알라모파이어 압축파일 unzip 완료 📦: \(CFAbsoluteTimeGetCurrent() - startTime)")
//                            print("unzippedFile(1): \(unzippedFile)")
//                            CorpCodeRepository.standard.deleteAllItem() // 일단 해당렘 전체삭제
                            self.getDataFromXmlFile() // 파싱 함수 호출
                            print("알라모파이어 압축파일 unzip & XML parsing & realm 3천5백 row 저장 완료 🗞: \(CFAbsoluteTimeGetCurrent() - startTime)")
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
        
        DispatchQueue.global().async {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            let fileURL = self.documentDirectoryPath()?.appendingPathComponent("CORPCODE.xml")
            do {
                let data = try String(contentsOf: fileURL!, encoding: .utf8)
                
                let xml = XMLHash.lazy(data)
                
                let listsArr: [XMLListVO] = try xml["result"]["list"].value()
                
                //            let listedCorp: [CorpCodeRealmModel] = listsArr.filter { $0.stock_code != " " }.map {
                //
                //                let dartCd = $0.corp_code
                //                let name = $0.corp_name
                //                let stckCd = $0.stock_code
                //                let mDate = $0.modify_date
                //
                //                return CorpCodeRealmModel(corpCode: dartCd, corpName: name, stockCode: stckCd, modifyDate: mDate)
                //            }
                
                print("전체 데이터 parsing해서 배열담기 완료 🧮: \(CFAbsoluteTimeGetCurrent() - startTime)")
                CorpCodeRepository.standard.plusCorpCode(item: listsArr)
                
            } catch {
                print("xml 파일 내부의 raw값 가져오기 실패!")
            }
        }
    }
    
    // MARK: - 재무제표
    func fetchFinInfoAPI(type: Endpoint, dartCropCode: String, year: String, completionHandler: @escaping([DartFinInfoDTO]) -> ()) {
        
        let url = type.requestURL
        
        let parameter = ["crtfc_key": "\(APIKey.DART_KEY)",
                         "corp_code": "\(dartCropCode)",
                         "bsns_year": "\(year)",
                         "reprt_code": "11011",
                         "fs_div": "CFS"]
        
        AF.request(url,
                   method: .get,
                   parameters: parameter).validate(statusCode: 200..<500).response { response in
            switch response.result {
            case .success(let value):
                print("dart 재무제표 통신 성공이다!")

                let json = JSON(value)

                let itemData = json["list"].arrayValue
                
                let finInfoArr: [DartFinInfoDTO] = itemData.map { item -> DartFinInfoDTO in

                    let sjName = item["sj_nm"].stringValue
                    let labelID = item["account_id"].stringValue
                    let labelName = item["account_nm"].stringValue
                    let oneYearBF = item["thstrm_amount"].stringValue
                    let twoYearBF = item["frmtrm_amount"].stringValue
                    let threeYearBF = item["bfefrmtrm_amount"].stringValue

                    return DartFinInfoDTO(sjName: sjName, labelID: labelID, labelName: labelName, amount_1yr_bf: oneYearBF, amount_2yr_bf: twoYearBF, amount_3yr_bf: threeYearBF)
                }
                
                completionHandler(finInfoArr)
                
            case .failure(let error):
                print("erro당 \(error)")
            }
        }
    }

    // MARK: - 배당
    func fetchDividendAPI(type: Endpoint, dartCropCode: String, year: String, completionHandler: @escaping([DartDividendDTO]) -> ()) {
        
        let fullurl = type.requestURL
        
        let parameter = ["crtfc_key": "\(APIKey.DART_KEY)",
                         "corp_code": "\(dartCropCode)",
                         "bsns_year": "\(year)",
                         "reprt_code": "11011"]
        
        AF.request(fullurl, method: .get, parameters: parameter).responseData { response in
            switch response.result {
            case .success(let value):

                print("dart 배당금 통신 자체는 성공이다!")
                let json = JSON(value)

                let data = json["list"].arrayValue
                
                let diviInfoArr: [DartDividendDTO] = data.map { item -> DartDividendDTO in

                    let labelName = item["se"].stringValue
                    let stkKind = item["stock_knd"].stringValue
                    let oneYearBF = item["thstrm"].stringValue
                    let twoYearBF = item["frmtrm"].stringValue
                    let threeYearBF = item["lwfr"].stringValue

                    return DartDividendDTO(labelName: labelName, stockKind: stkKind, amount_1yr_bf: oneYearBF, amount_2yr_bf: twoYearBF, amount_3yr_bf: threeYearBF)
                }
                
                completionHandler(diviInfoArr)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}











