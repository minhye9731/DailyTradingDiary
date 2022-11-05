//
//  SettingViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 10/19/22.
//

import UIKit
import MessageUI
import AcknowList
import Toast

struct SettingList: Hashable {
    let id = UUID().uuidString
    let title: String
    let subTitle: String
}

final class SettingViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    let mainView = SettingView()
    
    var contents = [
        SettingList(title: "상장기업 데이터 업데이트하기", subTitle: ""),
        SettingList(title: "문의하기", subTitle: ""),
        SettingList(title: "리뷰쓰기", subTitle: ""),
        SettingList(title: "오픈소스 라이선스", subTitle: ""),
        SettingList(title: "버전", subTitle: "0.0.0"),
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingList>!
    
    override func loadView() {
        self.view = mainView
        mainView.collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
    
    override func configure() {
        self.tabBarController?.tabBar.isHidden = true
        mainView.collectionView.delegate = self
        setNav()
    }
    
}


// MARK: - compositional
extension SettingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingList> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.subTitle
            content.textProperties.color = .mainTextColor
            
            // 버전정보 표기
            if indexPath.row == 3 { content.secondaryText = self.currentAppVersion() }
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .backgroundColor
            cell.backgroundConfiguration = background
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, SettingList>()
        snapshot.appendSections([0])
        snapshot.appendItems(contents)
        dataSource.apply(snapshot)
    }
    
}

extension SettingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: self.updateCorpCodeData()
        case 1: self.sendEmailTapped()
        case 2: self.writeReviewTapped()
        case 3: self.showPackageList()
        case 4: print("버전확인 - \(self.currentAppVersion())")
        default: print("tap")
        }
    }
}


// MARK: - 기타함수
extension SettingViewController {
    
    func setNav() {
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.tintColor = .pointColor
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .backgroundColor
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainTextColor, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
    
    func updateCorpCodeData() {
        let alert = UIAlertController(title: "<안내>", message: "기업등록 검색을 위한 상장기업 데이터를 업데이트 하시겠습니까?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "업데이트하기", style: .default) { _ in
            DARTAPIManager.shared.downloadCorpCode(type: .dartCorpCode)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    // 메일 보내기
    func sendEmailTapped() {
        if MFMailComposeViewController.canSendMail() {
            
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["jenney62639731@gmail.com"])
            compseVC.setSubject("Trady 문의사항")
            compseVC.setMessageBody("문의 사항을 상세히 입력해주세요.", isHTML: false)
            compseVC.modalPresentationStyle = .overFullScreen
            
            self.present(compseVC, animated: true, completion: nil)
            
        }
        else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    // 디바이스내 mail앱을 이용할 수 없는 경우
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인 후 재시도해주세요.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        sendMailErrorAlert.addAction(confirm)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // 메일 보내기 완료 후, 창닫기
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // 리뷰쓰기
    func writeReviewTapped() {
        
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id6443574203") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
    }
    
    // 라이브러리 리스트 화면
    func showPackageList() {
        let vc = AcknowListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 현재 버전
    func currentAppVersion() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "nil"
    }
}
