//
//  GarbageProtocol.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 1..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import Foundation

protocol DayProtocol{
    var day : String? {get set}
    var comment : String? {get set}
    var img : String? {get set}
    
    
    func getDay() -> String?
    func getComment() -> String?
    func getimg() -> String?
}

protocol JsonParserProtocol{
    var list : [DayVO] {get set}
}

protocol CleanHouseAPIProtocol{
    var currentElement: String {get set}
    var passData: Bool {get set}
    
    var parseAddress: Bool {get set}
    var parseDong: Bool {get set}
    var parseLocation: Bool {get set}
    var parseMapx: Bool {get set}
    var parseMapy: Bool {get set}
    
    var address: String {get set}
    var dong: String {get set}
    var location: String {get set}
//    var mapx: Double {get set}
//    var mapy: Double {get set}

    var mapx: String {get set}
    var mapy: String {get set}
}

protocol CleanHouseAPIParser{
    
}
