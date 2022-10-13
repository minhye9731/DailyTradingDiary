//
//  AppDelegate.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/14/22.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // firebase 초기화
        FirebaseApp.configure()
        
        // 원격 알림 시스템에 앱을 등록
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// 애플 내장
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // foreground 상태에서도 알림 발송되도록 하는 함수
    // 포그라운드 알림 수신: 로컬/푸시 동일
    // ex) 카카오톡: 푸시마다 설정, 화면마다 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // .banner, .list: iOS14+
        completionHandler([.badge, .sound, .banner, .list])
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is InfoViewController {
            // 제약 조건을 다르게 설정할 수도 있음
            completionHandler([])
        } else {
            // .banner, .list: iOS14+
            completionHandler([.badge, .sound, .banner, .list])
        }
        
    }
    
    // 푸시 클릭: 호두과자 장바구니 담는 화면
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("사용자가 푸시를 클릭했습니다.")
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        print(viewController)
        
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("key")] as? String == "1" {
            print("아침 응원 메시지 입니다.")
            viewController.tabBarController?.selectedIndex = 1
        } else {
            print("NOTHING")
        }
    
        
        // 현재뷰가 home뷰면 인포로 보낸다
        if viewController is HomeViewController {
            viewController.tabBarController?.selectedIndex = 1
            
        } else if viewController is CorpAnalysisViewController {
            
            // 시도1 - 정상적으로 옮겨지긴 하지만 tab bar가 사라짐
            // viewController.tabBarController?.selectedIndex = 1
            
            // 시도2 - 정상적으로 옮겨지고 tab bar도 보이지만, viewController의 deinit이 이루어지지 않음
            // viewController.navigationController?.popViewController(animated: true)
            
            viewController.navigationController?.popViewController(animated: true)?.tabBarController?.selectedIndex = 1

        } else if viewController is TradingDiaryViewController {
            
            // 시도1 - 정상적으로 옮겨지긴 하지만 tab bar가 사라짐
            // viewController.tabBarController?.selectedIndex = 1
            
            // 시도2 - 정상적으로 옮겨지고 tab bar도 보이지만, viewController의 deinit이 이루어지지 않음
            // viewController.navigationController?.popViewController(animated: true)
            
            viewController.navigationController?.popViewController(animated: true)?.tabBarController?.selectedIndex = 1

        } else if viewController is TradeRecordViewController {
            // 여기서 잘 안된다ㅠㅠ
//            viewController.popoverPresentationController?.presentedViewController.tabBarController?.selectedIndex = 1
//            viewController.dismiss(animated: true)
//            viewController.tabBarController?.selectedIndex = 1
        }
        
    }
    
    
    
    
}

// firebase
extension AppDelegate: MessagingDelegate {
    
    // 토큰 갱신 모니터링 : 토큰 정보가 언제 바뀔까?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}
