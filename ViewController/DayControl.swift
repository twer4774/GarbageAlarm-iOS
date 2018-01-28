//
//  DayControl.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 15..
//  Copyright © 2017년 WonIk. All rights reserved.
//

import Foundation
import UIKit

class DayControl{
    
    //Calendar에서 현재 요일 확인
    func calDay() -> Int{
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = cal.dateComponents([.weekday], from: now)
        
        var calDay = comps.weekday! //숫자로 표기됨
        
        return calDay
    }
    
    
    //캘린더 요일을 한글화시킴
    func getDay() -> String{
        
        var day = ""
        
        //숫자를 한글로 변환하기 위한 스위치문
        switch calDay(){
        case 1:
            day = "일요일"
        case 2:
            day = "월요일"
        case 3:
            day = "화요일"
        case 4:
            day = "수요일"
        case 5:
            day = "목요일"
        case 6:
            day = "금요일"
        case 7:
            day = "토요일"
        default:
            print("요일을 찾을 수 없습니다.")
        }
        
        return day
    }
    
    //JSON에서 저장한 commnet
    func getComment() -> String{
       var comment = ""
        
        var dvo = DayVO()
        dvo.getJSON()
    
        for i in dvo.list{
            if(getDay() == i.day){
             comment = i.comment!
            }
        }
        
        print(comment)
        return comment
    }
  
    
    //요일에 맞추어 메모 푸시로 보내기
    func getMemo() -> String?{
        
        let ud = UserDefaults.standard
        
        let memo = ud.string(forKey: "memo\(calDay())")
        
       
        return memo
    }
}
