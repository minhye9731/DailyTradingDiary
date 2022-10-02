////
////  DartFinInfoResponse.swift
////  DailyTradingDiary
////
////  Created by 강민혜 on 10/1/22.
////
//
//import Foundation
//
//// MARK: - FinInfoResponse
//struct FinInfoResponse: Decodable {
//    let status, message: String
//    let list: [List]
//}
//
//// MARK: - List
//struct List: Decodable {
//    let rceptNo, reprtCode, bsnsYear, corpCode: String
//    let sjDiv: SjDiv
//    let sjNm: SjNm
//    let accountID, accountNm: String
//    let accountDetail: AccountDetail
//    let thstrmNm: ThstrmNm
//    let thstrmAmount: String
//    let frmtrmNm: FrmtrmNm
//    let frmtrmAmount: String
//    let bfefrmtrmNm: BfefrmtrmNm
//    let bfefrmtrmAmount, ord: String
//    let currency: Currency
//    let thstrmAddAmount: String?
//
//    enum CodingKeys: String, CodingKey {
//        case rceptNo = "rcept_no"
//        case reprtCode = "reprt_code"
//        case bsnsYear = "bsns_year"
//        case corpCode = "corp_code"
//        case sjDiv = "sj_div"
//        case sjNm = "sj_nm"
//        case accountID = "account_id"
//        case accountNm = "account_nm"
//        case accountDetail = "account_detail"
//        case thstrmNm = "thstrm_nm"
//        case thstrmAmount = "thstrm_amount"
//        case frmtrmNm = "frmtrm_nm"
//        case frmtrmAmount = "frmtrm_amount"
//        case bfefrmtrmNm = "bfefrmtrm_nm"
//        case bfefrmtrmAmount = "bfefrmtrm_amount"
//        case ord, currency
//        case thstrmAddAmount = "thstrm_add_amount"
//    }
//}
//
//enum AccountDetail: String, Decodable {
//    case empty = "-"
//    case 연결재무제표Member = "연결재무제표 [member]"
//    case 자본Member비지배지분Member = "자본 [member]|비지배지분 [member]"
//    case 자본Member지배기업의소유주에게귀속되는자본Member = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]"
//    case 자본Member지배기업의소유주에게귀속되는자본Member기타자본구성요소Member = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|기타자본구성요소 [member]"
//    case 자본Member지배기업의소유주에게귀속되는자본Member미처분이익잉여금 = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|미처분이익잉여금"
//    case 자본Member지배기업의소유주에게귀속되는자본Member자기주식 = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|자기주식"
//    case 자본Member지배기업의소유주에게귀속되는자본Member자본금Member = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|자본금 [member]"
//    case 자본Member지배기업의소유주에게귀속되는자본Member적립금 = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|적립금"
//    case 자본Member지배기업의소유주에게귀속되는자본Member주식발행초과금 = "자본 [member]|지배기업의 소유주에게 귀속되는 자본 [member]|주식발행초과금"
//}
//
//enum BfefrmtrmNm: String, Decodable {
//    case 제3기 = "제 3 기"
//}
//
//enum Currency: String, Decodable {
//    case krw = "KRW"
//}
//
//enum FrmtrmNm: String, Decodable {
//    case 제4기 = "제 4 기"
//}
//
//enum SjDiv: String, Decodable {
//    case bs = "BS"
//    case cf = "CF"
//    case cis = "CIS"
//    case sce = "SCE"
//}
//
//enum SjNm: String, Decodable {
//    case 자본변동표 = "자본변동표"
//    case 재무상태표 = "재무상태표"
//    case 포괄손익계산서 = "포괄손익계산서"
//    case 현금흐름표 = "현금흐름표"
//}
//
//enum ThstrmNm: String, Decodable {
//    case 제5기 = "제 5 기"
//}
//
