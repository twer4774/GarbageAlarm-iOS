//
//  AlarmViewController.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 13..
//  Copyright © 2017년 WonIk. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds


class AlarmViewController: UIViewController, GADBannerViewDelegate {

    let timeSelector: Selector = #selector(AlarmViewController.updateTime)
    let interval = 1.0
    var count = 0
    var alramTime: String?
    var alertFlag = false
    
    var bannerView: GADBannerView!
    
    @IBOutlet var datePickerView: UIDatePicker!
    @IBOutlet var lbSelectTime: UILabel!
    @IBOutlet var btnSave: UIButton!
    
    //push 알람을 위한 객체 생성
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    //DayControl객체 생성
    let dayC = DayControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "YourID"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //시간 체크 - 스케줄러이용
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        
        //알람 등록
        center.requestAuthorization(options: options, completionHandler: {didAllow, erorr in
            print("Something went wrong")
        })
        
        btnSave.isEnabled = false

    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
  
    
    @IBAction func changeTime(_ sender: UIDatePicker){
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        lbSelectTime.text = "선택시간: " + formatter.string(from: datePickerView.date)
        
        //알람을 위한 설정
        formatter.dateFormat = "hh:mm aaa"
        alramTime = formatter.string(from: datePickerView.date)
     
//        if(self.datePickerView.date <= Date()){
//
//        }
        btnSave.isEnabled = true
        /*
        if (self.datePickerView.date <= Date()){
            let alert = UIAlertController(title: "현재 시간이후로 설정해 주세요", message: "부탁드립니다", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in
    
            })
            alert.addAction(ok)
            self.present(alert, animated: false)
        } else {
            btnSave.isEnabled = true
        }
        */
//        NSLog(formatter.string(from: self.datePickerView.date))
//        NSLog("\(self.datePickerView.calendar)")
//        NSLog("\(self.datePickerView.timeZone)")
        
    }
   
  
    
    enum pickerViewError: Error{
        case pastTime
        case nowTime
    }
    @IBAction func save(_ sender: Any) {
        
        //알림 설정 내용 확인
        let setting = UIApplication.shared.currentUserNotificationSettings
        guard setting?.types != .none else {
            let alert = UIAlertController(title: "알림등록", message: "알림이 허용되어있지 않습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in
                
            })
            
            alert.addAction(ok)
            
            self.present(alert, animated: false)
            return
        }
        localNotification()
    }

    func localNotification(){
        let date = Date()

        //버젼별로 나누어 알림 구현
        if #available(iOS 11, *){
            let localContent = UNMutableNotificationContent()
            localContent.title = "오늘은 \(dayC.getDay())"
            localContent.subtitle = "[\(dayC.getComment())] 버리는 날입니다."
            if let memo = dayC.getMemo(){
                localContent.body = "메모는 \(dayC.getMemo()!) 입니다"
            } else {
                localContent.body = "메모가 없습니다."
            }
            
            localContent.sound = UNNotificationSound.default()
            localContent.badge = 1
            //발송시각을 지금으로부터 *초 형식으로 변환
            let time = self.datePickerView.date.timeIntervalSinceNow
        
            //발송조건 정의
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            var newDate = DateComponents()
        
            let formatter = DateFormatter()
            //시간
            formatter.dateFormat = "HH"
            let selHour = formatter.string(from: datePickerView.date)
            newDate.hour = Int(selHour)
            //분
            formatter.dateFormat = "mm"
            let selMinute = formatter.string(from: datePickerView.date)
            newDate.minute = Int(selMinute)
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newDate, repeats: true)
            //발송 요청 객체 정의
            let request = UNNotificationRequest(identifier: "alarm", content: localContent, trigger: trigger)
            
            
            //노티피케이션 센터에 추가
            UNUserNotificationCenter.current().add(request){
                //알림 등록이 완료되면 사용자에게 알려줌
                (_) in
                //우리나라 시간으로 맞추기 위해 9시간 60분 60초 곱함 == 9시간 더한것
//                let date = self.datePickerView.date.addingTimeInterval(9*60*60)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH시 mm분"
                let date = formatter.string(from: self.datePickerView.date)
                
                let message = "알림이 등록되었습니다. 등록된 알림은 매일 \(date)에 발송됩니다."
                
                let alert = UIAlertController(title: "알림등록", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    
                })
                alert.addAction(ok)
                
                self.present(alert, animated: false)
                
            }
            
            
            
        }
        
    }
    //DatePicker 시간변경
    @objc func updateTime(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"

        
        let currentTime = formatter.string(from: date)
      
        
        if(currentTime == alramTime){
            if !alertFlag{
            let alert = UIAlertController(title: "지정알람 알림", message: "지정된 시간입니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in
            })
            alert.addAction(ok)
            self.present(alert, animated: false)
            }
        } else {
            alertFlag = false
        }
    
    }
}
