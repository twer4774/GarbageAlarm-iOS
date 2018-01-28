//
//  JsonParser.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 17..
//  Copyright © 2017년 WonIk. All rights reserved.
//

import Foundation

class JsonParser{
    
    var list:[DayVO] = []
    
    //JSON데이터 불러오기
    func getJSON(){
        //파일 경로불러오기
        let jsonFilePath = Bundle.main.url(forResource: "sample", withExtension: "json")
        //파일 경로를 Data객체에 넣기 - Data는 읽어들인 값들을 저장하는 역할.
        let jsonData = try! Data(contentsOf: jsonFilePath!)
        
        do {
            // JSON객체를 Data형태에서 NSDictionary형태로 타입 캐스팅(json구조에 맞추기)
            let jsonDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            
            //jsonDictionary에서 data에 속한 값들을 불러오기 위함
            let jsonObj = jsonDictionary["data"] as! NSArray
            
            for listIndex in jsonObj{
                let obj = listIndex as! NSDictionary
                
                
                let day = obj["day"]
                let comment = obj["comment"]
                let img = obj["img"]
                
                let dvo = DayVO(day: day as! String?, comment: comment as! String?, img: img as! String?)
                
                self.list.append(dvo)
                
            }
        }
        
    }
        
}

 

