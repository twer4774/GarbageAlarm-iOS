//
//  GarbageProtocolExtention.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 5..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import Foundation

//JSON불러오기
extension JsonParserProtocol{
    mutating func getJSON(){
        
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
                
                list.append(dvo)
                
            }
        }
        
    }
}

/*
//CleanHouseAPI불러오기
extension CleanHouseAPIProtocol{
   func getAPI(){
    var parser = XMLParser()
        let url = "http://openapi.jejusi.go.kr/rest/cleanhouseinfoservice/getCleanHouseInfoList?serviceKey=HEMqSS9qIbeCyhbdvp3KhAg8m93qSX2foRKOlk4y4%2B4KBFlp1LKnvBslwhcRvXIPkvKrXiehWXrWNXalpqAASg%3D%3D&pageNo=1&startPage=1&numOfRows=1877&pageSize=1877"
        
        let urlToSend: URL = URL(string: url)!
        
        //parse the xml
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        
        //가장 먼저 실행되어 delegate에 속한 4개의 parser함수를 실행함
        let success: Bool = parser.parse()
        
        if success {
            print("parse success!")
            //  print(strXMLData)
            
        } else {
            print("parse failure!")
        }
        
        //  lbTest.text = strXMLData
        /*
        for i in cleanHM.mapx{
            XPoint.append(cleanHM.mapx[i])
            YPoint.append(cleanHM.mapy[i])
        }
        //XPoint = cleanHM.mapx as [Double]
        //YPoint = cleanHM.mapy as [Double]
        addressArray = cleanHM.address + cleanHM.location
        */
//        print(XPoint)
    }
    //parser가 시작태그를 만나면 호출
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if(elementName == "address" || elementName == "dong" || elementName == "location" || elementName == "mapx" || elementName == "mapy"){
            switch elementName {
            case "address":
                parseAddress = true
            case "dong":
                parseDong = true
            case "location":
                parseLocation = true
            case "mapx":
                parseMapx = true
            case "mapy":
                parseMapy = true
                
            default:
                print("실패")
            }
            passData = true
        }
        
        /*
         if(elementName == "address" || elementName == "dong" || elementName == "location" || elementName == "mapx" || elementName == "mapy"){
         if(elementName == "address"){
         passName = true
         }
         passData = true
         }
         */
    }
    
    //parser가 닫는 태그를 만나면 호출
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        
        if(elementName == "address" || elementName == "dong" || elementName == "location" || elementName == "mapx" || elementName == "mapy"){
            switch elementName {
            case "address":
                parseAddress = false
            case "dong":
                parseDong = false
            case "location":
                parseLocation = false
            case "mapx":
                parseMapx = false
            case "mapy":
                parseMapy = false
                
            default:
                print("닫기 실패")
            }
            passData = false
        }
        
        
        /*
         if(elementName == "address" || elementName == "dong" || elementName == "location" || elementName == "mapx" || elementName == "mapy"){
         if(elementName == "address"){
         passName = false
         }
         passData = false
         }
         */
    }
    
    //현재 태그에 담겨 있는 string 전달
    func parser(_ parser: XMLParser, foundCharacters string: String, foundCharacters double: Double) {
        //        if(passName){
        //            strXMLData = strXMLData + "\n\n"+string
        //        }
        
        /*
        if(parseAddress){
            cleanHM.address.append(string)
        }
        if(parseDong){
            cleanHM.dong.append(string)
        }
        if(parseLocation){
            cleanHM.location.append(string)
        }
        if(parseX){
            cleanHM.mapx.append(double)
        }
        if(parseY){
            cleanHM.mapy.append(double)
        }
        */
        var paddress: String = ""
        var pdong: String = ""
        var plocation: String = ""
        var pmapx: Double = 0.0
        var pmapy: Double = 0.0
        if(parseAddress){
            paddress = string
        }
        if(parseDong){
            pdong = string
        }
        if(parseLocation){
            plocation = string
        }
        if(parseMapx){
            pmapx = double
        }
        if(parseMapy){
            pmapy = double
        }
        let clean = CleanHouseModel(address: paddress, dong: pdong, location: plocation, mapx: pmapx, mapy: pmapy)
        /*
         if(parseAddress){
         cleanHM.address = cleanHM.address + "\n\n" + string
         }
         if(parseDong){
         cleanHM.dong = cleanHM.dong + "\n\n" + string
         }
         if(parseLocation){
         cleanHM.location = cleanHM.location + "\n\n" + string
         }
         if(parseX){
         cleanHM.mapx = cleanHM.mapx + "\n\n" + string
         }
         if(parseY){
         cleanHM.mapy = cleanHM.mapy + "\n\n" + string
         }
         */
        /*
         if(passData){
         strXMLData = strXMLData + "\n\n" + string
         
         print("foundCharacter: \(string)")
         }
         
         */
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
}
*/
