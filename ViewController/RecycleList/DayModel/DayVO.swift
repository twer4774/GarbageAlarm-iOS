//
//  DayVO.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 12..
//  Copyright © 2017년 WonIk. All rights reserved.
//

//Cell 요소 속성 변경. Value Object패턴 - model
import Foundation

import UIKit //UIImage추가


class DayVO: DayProtocol, JsonParserProtocol{
    var day: String?
    var comment: String?
    var img: String?
    var imgView: UIImage? //이미지뷰에 표시

    var list = [DayVO]()
    
    init(){
    
    }
 
    init(day: String?, comment: String?, img: String?){
        self.day = day
        self.comment = comment
        self.img = img
    
        
    }
    
    
    func getDay() -> String? {
        return day
    }
    
    func getComment() -> String? {
        
        return comment
    }
    
    func getimg() -> String? {
        return img
    }
    
    
    
}
