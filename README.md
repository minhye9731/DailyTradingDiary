![핵심이미지 5개](https://user-images.githubusercontent.com/53211818/209333185-4341b029-9387-4e03-b575-e5c00191383c.jpeg)

# Trady

![180](https://user-images.githubusercontent.com/53211818/208314586-89f7e358-a270-4807-9c29-0c3e97476d47.png)

###### [앱스토어에 다운받으러가기](https://apps.apple.com/kr/app/trady/id6443574203)

> 나만의 국내주식 매매일지 Trady📝
> - 관심기업의 재무정보를 확인하고 매매일지를 작성할 수 있습니다.
> - 시장의 과열 및 공포지수와 전 세계 경제 뉴스를 확인할 수 있습니다.
> - 투자원금 대비 기업별 보유자산 구성을 확인할 수 있습니다.
> - 기간별, 매수/매도 구분에 따른 매매내역을 조회하고 매매금액을 한 눈에 볼 수 있습니다.

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
##### 홈

##### 관심기업 등록, 매매일지 작성

##### Info

##### 자산현황, 매매내역 확인 

## 트러블 슈팅
- **구조**
    - realm데이터 핸들링 메서드를 정리한 `protocol`과 `Singleton` 사용으로 코드 사용성 개선
    - 통신데이터를 기준으로 관련 메서드끼리 `class`로 분리해 각 API의 역할을 분명하게 구분
    - empty view, 재무데이터를 보여줄 표 등 구성시 `Custom UIView` 생성하여 코드의 재사용성 향상
    - 매매일지내 각 section내 요소에 입력된 데이터들 저장시 중복사용되는 `UITextField`들에 대해 `tag`사용하여 명확히 구분
    - 화면 재사용
    1) 접근화면(home, 매매내역)에 따라 ‘매매일지 작성화면’의 `페이지 모드 enum`으로 구분하여 `화면 재사용`
    2) 접근화면(관심기업 등록, 매매일지 작성)에 따라 ‘기업 검색화면’의 `페이지 모드 enum`으로 구분하여 `화면 재사용`
    ([20220929학습일지](https://www.notion.so/20220929-c2f7da77d03c4cc68f6abad5042d25f5))
- **데이터**
    - 다수 생성한 구조체들을 `DTO`로 구분하여 기능별 명확한 분리
        [DTO 적용](https://www.notion.so/DTO-8bd3599f4b914527b801719771bd9560)
    - `Realm List`를 사용하여 사용자가 작성한 관심기업 및 매매일지 데이터 구조화 & 해당관계 고려한 메서드 생성
        [realm list](https://www.notion.so/realm-list-052bbabbfafc49669b8c5ee6bdbc4b74)
    - 매매일지, 기업등록 입력항목 저장시 `enum`으로 신규입력 & 수정모드 `페이지모드` 구분해주고, 작성 후 뒤로가기시 입력사항 저장되지 않도록 `신규입력용, 업데이트용 변수`를 생성해서 활용
    ([09.18](https://www.notion.so/20220918-5f04cc59c9334c65b6e6f8ef7c25b7af))
- **네트워크**
    - 상장기업 재무정보를 바탕으로 `Alamofire`를 이용한 `http`통신 및 `status code`별 분기처리 대응
    - 다수의 네트워크를 연속적으로 통신하는 등 데이터 구조의 상세한 사전설계 중요성을 경험
- **사용자 경험(UX)**
    - 상장기업 API 조회 및 다운로드시 XML Parsing작업 `비동기처리`로 `UI Blocking` 해결
        [20220928학습일지](https://www.notion.so/20220928-4a72a83988164f12876735fff19f7165)
    - `앱스토어 리뷰 대응`으로 `Firebase Crachlytics`로 문제해결 후, 다양한 Use case 처리 중요성을 경험
    - 사용자의 다양한 앱사용 경험을 위한 `Dark Mode` 지원
    - `UIBezierPath` 로 파이그래프 생성하고 `CABasicAnimation`을 적용하여 매매내역 기준 사용자의 자산 분배현황 가시성을 표현


## 회고


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
