//
//  AppDelegate.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 12..
//  Copyright © 2017년 WonIk. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /*
    //메모 내용 저장
    var memo1: String? = "메모해주세요" //일
    var memo2: String? = "메모해주세요" //월
    var memo3: String? = "메모해주세요" //화
    var memo4: String? = "메모해주세요" //수
    var memo5: String? = "메모해주세요" //목
    var memo6: String? = "메모해주세요" //금
    var memo7: String? = "메모해주세요" //토
    */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    /*
        //경고창, 배지, 사운드를 사용하는 알림환경정보를 생성하고, 애플리케이션에 저장
        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings((setting))
        
        //앱이 알림으로 실행된 경우, 알림과 관련된 처리
        if let localNoti = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification{
        
        //활성화상태와 비활성화 상타ㅐ 구분
        if application.applicationState == UIApplicationState.active{
            //앱이 활성화 된 상태일때 실행 로직
        } else if application.applicationState == .inactive{
            //앱이 비활성화 된 상태일때 실행할 로직
        }
        }
 */
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1352730386935913~4558019311")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    /*
        //iOS버전에따라 설정
        if #available(iOS 11.0, *){
            //새로운 로컬 아릶 구현 코드
            //알림설정 확인
            let setting = application.currentUserNotificationSettings
            guard setting?.types != .none else {
                print("알림을 보낼 수 없음")
                return
            }
            //알림 콘텐츠 객체
            let localContent = UNMutableNotificationContent()
            localContent.badge = 1
            localContent.body = "오늘은 00요일입니다"
            localContent.title = "로컬알림 메시지 - comment"
            localContent.subtitle = "메모넣기"
            localContent.sound = UNNotificationSound.default()
            
            //알림 발송 조건
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) //3초뒤 반복없이
            
            //알림 요청 객체
            let request = UNNotificationRequest(identifier: "garbage", content: localContent, trigger: trigger)
            
            //NotificationCenter에 추가
            UNUserNotificationCenter.current().add(request)
        } else {
            //iOS 11버젼이전에서의 알람
            //알림 설정 확인
            let setting = application.currentUserNotificationSettings
            
            //알림 설정이 되어 있지 않다면, 로컬 알림을 보내도 받을 수 없으므로 종료됨
            guard setting?.types != .none else {
                print("알림으로 보낼 수 없음")
                return
            }
            
            //로컬 알림 인스턴스 생성
            let noti = UILocalNotification()
            
            noti.fireDate = Date(timeIntervalSinceNow: 10) //10초 후 발송
            noti.timeZone = TimeZone.autoupdatingCurrent //현재 위치에 따라 타임존 설정
            noti.alertBody = "오늘은 00요일입니다."
            noti.alertAction = "앱 실행하기" //잠금상태일때 표시될 액션
            noti.applicationIconBadgeNumber = 1 //배지 갯수
            noti.soundName = UILocalNotificationDefaultSoundName
            
            application.scheduleLocalNotification(noti)
        }
 */
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //뱃지 없애기
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

