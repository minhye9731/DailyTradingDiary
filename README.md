![핵심이미지 5개](https://user-images.githubusercontent.com/53211818/209333185-4341b029-9387-4e03-b575-e5c00191383c.jpeg)

# Trady - 나만의 국내주식 매매일지 📝 

![180](https://user-images.githubusercontent.com/53211818/208314586-89f7e358-a270-4807-9c29-0c3e97476d47.png)

### [⭐️앱스토어에 다운받으러가기⭐️](https://apps.apple.com/kr/app/trady/id6443574203) 

* 핵심 기능
  * ✍️ 관심기업의 재무정보를 확인하고 매매일지를 작성할 수 있습니다.
  * 🌏 시장의 과열 및 공포지수와 전 세계 경제 뉴스를 확인할 수 있습니다.
  * 📊 투자원금 대비 기업별 보유자산 구성을 확인할 수 있습니다.
  * 💵 기간별, 매수/매도 구분에 따른 매매내역을 조회하고 매매금액을 한 눈에 볼 수 있습니다.

* 프로젝트 목적
  * ✅ iOS 앱 개발&배포 Lifecycle 경험하기 (앱 아카이빙/배포/Testflight/운영)
  * ✅ 네트워크 통신, 데이터 구조, Realm 핸들링 집중해서 작업하기
  * ✅ Firebase Analytics, Firebase Crashlytics의 객관적인 데이터기반 실사용자와의 소통 경험
  

## 개발기간
- 2022.09.08 ~ 2022.10.06 (4주)

## 개발환경
* Xcode 14.1.0
* Deployment Target iOS 15.0

## 기술스택 및 라이브러리
- UIKit, Singleton, Repository
- GCD, Extension, Protocol, Closure, UserDefaults, DarkMode, WKWebView
- Autolayout, Snapkit, Compositional Layout, CABasicAnimation, UIBezierPath
- MVC
- Firebase Analytics, Firebase Crashlytics, Firebase Messaging
- Local Notification 
- Alamofire, SwiftyJSON
- JSON parsing, Realm, Diffable DataSource
- IQKeyboardManagerSwift, Toast, Tabman, Zip, Kingfisher, FSCalendar

## API
* [[공공데이터포털] 금융위원회_KRX상장종목정보](https://www.data.go.kr/iim/api/selectDevAcountList.do)
* [[공공데이터포털] 금융위원회_주식시세정보](https://www.data.go.kr/iim/api/selectAPIAcountView.do)
* [[DART] 고유번호 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS001&apiId=2019018)
* [[DART] 단일회사 전체 재무제표 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS003&apiId=2019020)
* [[DART] 배당에 관한 사항 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS002&apiId=2019005)
* [[ALPHA ADVANTAGE] Market News & Sentiment](https://www.alphavantage.co/documentation/)
* [Fear and Greed Index](https://rapidapi.com/rpi4gx/api/fear-and-greed-index)

## 화면별 주요기능
- realm데이터 핸들링 메서드를 정리한 `protocol`과 `Singleton` 사용으로 코드 사용성 개선
- 통신데이터를 기준으로 관련 메서드끼리 `class`로 분리해 각 API의 역할을 분명하게 구분
- empty view, 재무데이터를 보여줄 표 등 구성시 `Custom UIView` 생성하여 코드의 재사용성 향상
- 매매일지내 각 section내 요소에 입력된 데이터들 저장시 중복사용되는 `UITextField`들에 대해 `tag`사용하여 명확히 구분
- 화면 재사용
    - 접근화면(home, 매매내역)에 따라 ‘매매일지 작성화면’의 `페이지 모드 enum`으로 구분하여 `화면 재사용`
    - 접근화면(관심기업 등록, 매매일지 작성)에 따라 ‘기업 검색화면’의 `페이지 모드 enum`으로 구분하여 `화면 재사용`
- 다수 생성한 구조체들을 `DTO`로 구분하여 기능별 명확한 분리
- `Realm List`를 사용하여 사용자가 작성한 관심기업 및 매매일지 데이터 구조화 & 해당관계 고려한 메서드 생성
- 매매일지, 기업등록 입력항목 저장시 `enum`으로 신규입력 & 수정모드 `페이지모드` 구분해주고, 작성 후 뒤로가기시 입력사항 저장되지 않도록 `신규입력용, 업데이트용 변수`를 생성해서 활용
- 상장기업 재무정보를 바탕으로 `Alamofire`를 이용한 `http`통신 및 `status code`별 분기처리 대응
- 다수의 네트워크를 연속적으로 통신하는 등 데이터 구조의 상세한 사전설계 중요성을 경험
- 상장기업 API 조회 및 다운로드시 XML Parsing작업 `비동기처리`로 `UI Blocking` 해결
- `앱스토어 리뷰 대응`으로 `Firebase Crachlytics`로 문제해결 후, 다양한 Use case 처리 중요성을 경험
- 사용자의 다양한 앱사용 경험을 위한 `Dark Mode` 지원
- `UIBezierPath` 로 파이그래프 생성하고 `CABasicAnimation`을 적용하여 매매내역 기준 사용자의 자산 분배현황 가시성을 표현

## 트러블 슈팅
[📗트러블슈팅 list 상세보기](https://mhkang.notion.site/SeSAC-Study-Recruit-19818240bbff4f32978af0f1f7e87f9f)

* 관심기업 RealmModel Object와 매매일지 RealmModel Object간의 `Realm List` 관계를 고려한 `CRUD` 작업 시 이슈  
    &rarr; (EX.매매일지 작성) 객체 추가작업을 위한 `write Transaction` 처리 시 두 RealModel간의 `To-Many Relationship`을 고려하여 `parent`단을 거쳐서 CRUD 작업
    
```swift
class CorpRegisterRepository: RegisterRepositoryType {
    
    private init() { }
    static let standard = CorpRegisterRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<CorpRegisterRealmModel>!

    func plusDiaryatList(item: TradingDiaryRealmModel) { // parent 찾아가기
        let corp = CorpRegisterRepository.standard.localRealm.objects(CorpRegisterRealmModel.self).where{ $0.corpName == item.corpName }
        do {
            try localRealm.write{
                corp.first?.tradingDiaries.append(item) // parent의 tradingDiaries 리스트에 추가해주기
            }
        } catch _ {
            UIApplication.getTopVC()?.view.makeToast("잠시 후 다시 시도해주세요", duration: 1.0, position: .center)
        }
    }

}
```   
<br>  


* `Main thread`에서 특정 처리작업 소요시간이 길어짐으로 인해 `UI Blocking` 발생하는 이슈.  
    &rarr; [`Alamofire`로 Zip파일 unzip → `SWXMLHash`로 unzip된 xml파일들 `XML Parsing` → `realm` DB에 저장]이라는 연속적인 작업 중, 가장 소요시간이 길었던 xml parsing 작업을 `Background`에서 `비동기적`으로 처리하여 해결
    
```swift
// 앱 첫 실행시 화면
final class WalkThroughViewController: BaseViewController {
    DARTAPIManager.shared.downloadCorpCode(type: .dartCorpCode)  // (1)
}
```

```swift
// API Manager
class DARTAPIManager {
    static let shared = DARTAPIManager()
    private init() { }
    
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
                guard let path = self.documentDirectoryPath() else { return }
                let sandboxFileURL = path.appendingPathComponent(baseURL.lastPathComponent)
                
                if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
                    let newfileURL = documentDirectoryPath.appendingPathComponent("\(fileName)")
                    
                    do {
                        try Zip.unzipFile(newfileURL, destination: documentDirectoryPath, overwrite: true, password: nil, progress: { progress in
                        }, fileOutputHandler: { unzippedFile in
                            self.getDataFromXmlFile() // (2)
                        })
                    } catch {
                        ...
                    }
                }
            case .failure(let error):
                ...
            }
        }
    }
    
    func documentDirectoryPath() -> URL? {...}

    func getDataFromXmlFile() {
        DispatchQueue.global().async {            
            let fileURL = self.documentDirectoryPath()?.appendingPathComponent("CORPCODE.xml") // (3)
                DispatchQueue.main.async {
                    CorpCodeRepository.standard.plusCorpCode(item: listsArr) // (4)
                }
        }
    }
}

```  

```swift
// realm repository
class CorpCodeRepository: CorpCodeRepositoryType {
    
    private init() {}
    static let standard = CorpCodeRepository()
    let localRealm = try! Realm()
    var tasks: Results<CorpCodeRealmModel>!

    func plusCorpCode(item: [XMLListVO]) {
            let filteredList = item.filter { $0.stock_code != " " }.map {
                let dartCd = $0.corp_code
                let name = $0.corp_name
                let stckCd = $0.stock_code
                let mDate = $0.modify_date
                return CorpCodeRealmModel(corpCode: dartCd, corpName: name, stockCode: stckCd, modifyDate: mDate)
            }
            
        try! localRealm.write({
            localRealm.delete(localRealm.objects(CorpCodeRealmModel.self))
            localRealm.add(filteredList)
        })
     }
  
}
```
<br>  


* `UIBezierPath`로 생성한 파이차트의 `CABasicAnimation` 구현 시 첫 번째 slice 누락 이슈  
    &rarr; `dispatch_after`로 PortfolioChartView가 메모리에 올라간 후 0.2초 후에 `CABasicAnimation`가 실행되도록하여 해결 

```swift
final class AssetStatusViewController: BaseViewController {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: ...
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetChartTableViewCell.reuseIdentifier) as? AssetChartTableViewCell else { return UITableViewCell() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 0.2초 후에
              cell.ratioChart.slices = self.slideArr.sorted(by: { $0.percent > $1.percent })
              cell.ratioChart.animateChart() // CABasicAnimation 실행
            }
        case 2: ...
        default: ...
        }
    }
}
```


## 회고

[🧐상세한 회고 보러가기![SeSAC Study Post-Mortem]](https://wannab-it-pm.tistory.com/121)

Good👍 Realm List를 사용해서 데이터를 구조화시킴  
Good👍 싱글톤 패턴으로 Realm을 사용하여 메모리 낭비를 방지하며, 여러 화면에서 Realm 데이터 사용함  
Good👍 별도 생성한 다수의 Struct들을 DTO, VO로 구분하여 사용함  
Good👍 Alamofire 통신시 status code별 분기처리 대응 
  
Bad👎 무리한 공수산정 &  뒤바뀐 작업 진행순서  
Bad👎 초기 기획시 미비했던 데이터 구조 상세설계  
Bad👎 기능별 상세 예외처리 방안 기획 누락  
  
프로젝트 진행시 최우선 목표였던 **앱 출시의 전반적인 LifeCycle**을 경험해보고  
적용하고자 했던 기술들(데이터 구조, API 통신 예외 처리, Realm 등)을 모두 다루어 보게 되어 의미가 있었다.  
    
기획/개발/운영까지 모두 혼자 작업을 하며 UI 뿐만 아니라 데이터 구조, 기능별 상세 로직에 대한 **쳬계적이고 명확한 기획**의 중요성을 느꼈다.  
무엇보다 정해진 **deadline**이 있을 경우, (어려운 방법을 적용하는 것에 매몰되기보다는..) 우선 현재 내 수준에서 구현 가능한 방법으로 해결하고 기획했던 **공수에 최대한 맞추고자** 노력하는 것 또한 매우 중요하다는 것을느꼈다.  
  
무엇보다 앱스토어에 올라오는 **별점 & Review를 확인해서, 피드백을 반영한 업데이트를 하고, 직접 사용자에게 댓글을 달아본 경험**은 앞으로도 절대 잊지 못할 것 같다.  
앱 출시로 끝이 아니라 앞으로도 꾸준히 운영 & 유지보수 & 개선해보며 Trady를 야무진 서비스로 디벨롭 하고싶다.  
  
앞으로 기술적으로 성장하는 것은 물론이고, 개발할 때에 **스크린 너머에 있을 사용자들을 항상 염두하며 작업하는 개발자**가 되자는 다짐을 하게 해준 프로젝트였다. 끝!


## 개발과정
|    구분     |   README   |   README   |   README   |   README   |
| ---------- | :--------: | :--------: | :--------: | :--------: |
| iteration1 |    기획     |     기획    |    기획     |    기획     |
| iteration2 | [20220912] | [20220913] | [20220914] |            |
| iteration3 | [20220915] | [20220916] | [20220917] | [20220918] |
| iteration4 | [20220919] | [20220920] | [20220921] |            |
| iteration5 | [20220922] | [20220923] | [20220924] | [20220925] |
| iteration6 | [20220926] | [20220927] | [20220928] |            |
| iteration7 | [20220929] | [20220930] | [20221001] | [20221002] |
| iteration8 | [20221003] | [20221004] |                        ||

   [20220912]: <https://mhkang.notion.site/20220912-136705c74f9e45c6ad94df19f0268b0f>
   [20220913]: <https://mhkang.notion.site/20220913-d39300201b6c49c8b1311aff0ee46e27>
   [20220914]: <https://www.notion.so/mhkang/20220914-c08b2812eae2421294281f1fb03335dc>
   
   [20220915]: <https://www.notion.so/mhkang/20220915-1ffd2b7af0cd4498820d2ed495d72340>
   [20220916]: <https://www.notion.so/mhkang/20220916-3b9b965d1f61478e94ed023901fead86>
   [20220917]: <https://www.notion.so/mhkang/20220917-9dcd8215604c40dc805b2e58df81aeef>
   [20220918]: <https://www.notion.so/mhkang/20220918-5f04cc59c9334c65b6e6f8ef7c25b7af>
   
   [20220919]: <https://www.notion.so/mhkang/20220919-54fe3e99d74540d7bee6f8281657ee9e>
   [20220920]: <https://www.notion.so/mhkang/20220920-73b64270a27e4141a146860e520620e9>
   [20220921]: <https://www.notion.so/mhkang/20220921-f71119991cd84486b2d5e9462d68e4a1>
   
   [20220922]: <https://www.notion.so/mhkang/20220922-6078840454194c6b9bcabb87aa074e67>
   [20220923]: <https://www.notion.so/mhkang/20220923-b22f64e999c7470fa8b11a97261039cc>
   [20220924]: <https://www.notion.so/mhkang/20220924-10c486f3bcb944a78a1dfa417600f0ff>
   [20220925]: <https://mhkang.notion.site/20220925-5f7fc908c468432fb14cb23145c66116>
   
   [20220926]: <https://mhkang.notion.site/20220926-57cf695f9acc4feb807a8695c1135d12>
   [20220927]: <https://mhkang.notion.site/20220927-ff99ea0a51a244b980a7b499de0de0b9>
   [20220928]: <https://mhkang.notion.site/20220928-4a72a83988164f12876735fff19f7165>
   
   [20220929]: <https://mhkang.notion.site/20220929-c2f7da77d03c4cc68f6abad5042d25f5>
   [20220930]: <https://mhkang.notion.site/20220930-4e0f0efc953840828b53eb71b5d5509d>
   [20221001]: <https://mhkang.notion.site/20221001-6e87122cef47453695c847523574ea9a>
   [20221002]: <https://mhkang.notion.site/20221002-73dc5e4d2e204ab0a99902f6dd54af21>
   
   [20221003]: <https://mhkang.notion.site/20221003-fc383dfd38b54a54a9a4eb179c32c561>
   [20221004]: <https://mhkang.notion.site/20221004-2480f435dcb4493e814306732bde877f>


## 업데이트 내역
* 1.2.0 (2022.12. 13)
    * 기업등록, 매매일지 텍스트 입력후 리턴키 생략시 버그 수정
    * 상장기업 데이터 업데이트시 기존 기업등록, 매매일지 내역 누락 버그 수정
* 1.1.0 (2022.11.07)
    * 설정 화면 추가
    * 자산현황내 보유기업별 리스트 표기용 UITableView 추가
    * 매매일지 매도건 등록시 해당기업 총 매수금액보다 큰 금액은 등록 불가능하도록 제한로직 추가
    * 상장기업 데이터 저장시 XML parsing작업 background에서 실행되도록 thread 처리
    * 매매내역 검색일자 조건 추가 및 버그수정
* 1.0.2 (2022.10.17)
    * 새로운 소식 전달을 위해 Remote Notification 적용 (FCM Messaging)
    * 데일리 알림 발송을 위한 Local Notification 추적용
    * 관심기업 등록시 입력사항 버그 수정
* 1.0.1 (2022.10.10)
    * 매매일지 리스트 화면 UI 개선
    * 첫 실행 사용자를 위한 앱 사용안내 정보를 전달하는 Splash 화면 추가
    * 버그 수정
* 1.0.0
    * 앱 출시
