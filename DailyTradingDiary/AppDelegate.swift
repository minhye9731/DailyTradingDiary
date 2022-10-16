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
import UserNotifications

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
        
        
        // local 메시지 설정
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        // remote 메시지 설정
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
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

// MARK: - 애플 내장 얼럿 코드
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // foreground 상태에서도 알림 발송되도록 하는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    // 푸시 클릭: 호두과자 장바구니 담는 화면
    // 유저가 푸시를 클릭했을 때에만 수신 확인 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("사용자가 푸시를 클릭했습니다.")
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        let application = UIApplication.shared
        
        // 작동 안함
        if application.applicationState == .inactive {
            if response.notification.request.content.title == "🗞 Time to be Trady 🗞" {
                NotificationCenter.default.post(name: Notification.Name("showInfoPage"), object: nil, userInfo: ["index": 1])
            }
        }
        
        // 작동 확인 완료
        if application.applicationState == .active {
            if response.notification.request.content.title == "🗞 Time to be Trady 🗞" {
                NotificationCenter.default.post(name: Notification.Name("showInfoPage"), object: nil, userInfo: ["index": 1])
            }
        }
 
    }
    
    
    
    
}

// MARK: - firebase alert 관련
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
