# Trady

![180](https://user-images.githubusercontent.com/53211818/208314586-89f7e358-a270-4807-9c29-0c3e97476d47.png)

###### [앱스토어에 다운받으러가기](https://apps.apple.com/kr/app/trady/id6443574203)

> 나만의 국내주식 매매일지를 작성하는 Trady📝
> (블라블라)


## 개발기간
- 2022.09.12 ~ 2022.10.05

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

## 개발환경
* Xcode 14.1.0
* Deployment Target iOS 15.0

## 기술스택 및 라이브러리
- UIKit, MVC, Singleton, Repository
- GCD, Extension, Protocol, Closure
- 코드베이스 Autolayout, Snapkit
- Firebase Analytics, Firebase Crashlytics, Firebase Messaging
- Local Notification 
- Alamofire
- Realm
- FSCalendar
- SwiftyJSON
- Kingfisher
- Tabman
- Zip
- Toast
- IQKeyboardManagerSwift

## API
* [[공공데이터포털] 금융위원회_KRX상장종목정보](https://www.data.go.kr/iim/api/selectDevAcountList.do)
* [[공공데이터포털] 금융위원회_주식시세정보](https://www.data.go.kr/iim/api/selectAPIAcountView.do)
* [[DART] 고유번호 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS001&apiId=2019018)
* [[DART] 단일회사 전체 재무제표 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS003&apiId=2019020)
* [[DART] 배당에 관한 사항 개발가이드](https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS002&apiId=2019005)
* [[ALPHA ADVANTAGE] Market News & Sentiment](https://www.alphavantage.co/documentation/)
* [Fear and Greed Index](https://rapidapi.com/rpi4gx/api/fear-and-greed-index)

## 개발과정
(정리중)

## 실행화면
##### Splash
![splash](https://user-images.githubusercontent.com/53211818/208316411-11570118-c9c7-49ea-982c-c2658c5253c9.jpg)

##### 홈
![홈1](https://user-images.githubusercontent.com/53211818/208316904-48a4a2cc-795e-45d5-a677-2e46121b73a3.jpg) ![홈2](https://user-images.githubusercontent.com/53211818/208316942-57fcca8e-b251-40a7-8116-d3e8d6fcdc6e.jpg) ![홈3](https://user-images.githubusercontent.com/53211818/208316986-351cdb12-4994-442d-97c6-c544fc2d69a1.jpg)

##### 검색
![검색1](https://user-images.githubusercontent.com/53211818/208317043-16ca9fea-f6ca-42e6-85bd-9044418cdc1b.jpg) ![검색2](https://user-images.githubusercontent.com/53211818/208317099-8a1b5dae-5f16-4473-a768-0c8bbd897408.jpg)

##### 관심기업 등록
![관심기업1](https://user-images.githubusercontent.com/53211818/208317147-cf584764-61e4-4b3b-a33a-8d2fb192459d.jpg) ![관심기업2](https://user-images.githubusercontent.com/53211818/208317190-76f41aee-4d4a-481d-b185-ae58860542d8.jpg)

##### 매매일지 작성
![매매일지1](https://user-images.githubusercontent.com/53211818/208316610-b33b25d7-ec93-47e7-8a46-d0e99efe79b0.jpg)

##### Info
![info1](https://user-images.githubusercontent.com/53211818/208316665-469ff9d2-46f0-4d15-9ea5-fc0420bfb4d0.jpg)

##### Portfolio
![포폴1](https://user-images.githubusercontent.com/53211818/208317261-dffe2b6a-7bc7-4f45-9cfc-fa7a3998ccd2.jpg) ![포폴2](https://user-images.githubusercontent.com/53211818/208317317-530ae086-1d80-4b62-b398-cad0ce305752.jpg) ![포폴3](https://user-images.githubusercontent.com/53211818/208317341-c377b9e8-f58a-4a95-b427-47482a880b16.jpg)

##### 설정
![설정](https://user-images.githubusercontent.com/53211818/208316787-5bf175aa-12ed-4180-95a2-b714a154d07b.jpg)


## 이슈사항
1. 시간이 소요되는 작업에 대한 background 작업처리
    * 문제사항
    * 기술적 관점 해결
    * 사용자 관점 해결
2. Realm 저장 데이터를 여러 화면에서의 사용시 용이성
    * 문제사항
    * 기술적 관점 해결
    * 사용자 관점 해결
3. 서비스 및 데이터 플로우를 고려한 데이터간 관계(relam list)
    * 문제사항
    * 기술적 관점 해결
    * 사용자 관점 해결
4. tableview의 각 section내의 동일한 UI요소들이 반복될 경우, tag로 구분하기
    * 문제사항
    * 기술적 관점 해결
    * 사용자 관점 해결
5. 네트워크 통신
    * 문제사항
    * 기술적 관점 해결
    * 사용자 관점 해결


