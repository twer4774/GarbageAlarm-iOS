//
//  DayViewController.swift
//  GarbageAlarm
//
//  Created by WonIk on 2017. 12. 12..
//  Copyright © 2017년 WonIk. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!

    var dvo = DayVO()
    let dayC = DayControl()
    
    override func viewDidLoad() {
        dvo.getJSON()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        //        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "YourID"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dvo.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //list를 행 단위로 맞춤
        let row = dvo.list[indexPath.row]

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell") as! DayCell
       
        
        cell.day?.text = row.day
        cell.comment?.text = row.comment
        cell.imageView?.image = UIImage(named: "\(row.img!)")
        

        //오늘 요일에 색상으로 표시
        if(dayC.getDay() == row.day){
            cell.contentView.backgroundColor = UIColor.white
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        //메모 표시하기
        let ud = UserDefaults.standard
        let memo = ud.string(forKey: "memo\(indexPath.row+1)")
        
        if let memo = memo {
            cell.lbTabMemo.text = memo
            cell.lbTabMemo.textColor = UIColor.blue
        } else {
            cell.lbTabMemo.text = "\(row.day!) 탭하여 메모하기"
            cell.lbTabMemo.textColor = UIColor.red
        }
        
        /*
        if let memo = memo {
            cell.lbTabMemo.text = memo
            cell.lbTabMemo.textColor = UIColor.blue
        } else if memo == "\(row.day!) 탭하여 메모하기"{
//            cell.lbTabMemo.text = "\(row.day!) 탭하여 메모하기"
            cell.lbTabMemo.textColor = UIColor.red
        }
        */
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = dvo.list[indexPath.row]
        
        //메모 값을 앱 종료 후에도 저장하기 위한 변수 - 앱을 삭제하기 전까지 메모가 저장됨
        let ud = UserDefaults.standard
        
        /* alert창 설정 */
        let title = "\(row.day!) 메모"
        
        //메모가 있는 상태이면 메모를 표시해줌
        var msg  = ud.string(forKey: "memo\(indexPath.row+1)")
    
        if let msg = msg {
            msg
        } else {
            msg = "메모해주세요"
            
        }
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let add = UIAlertAction(title: "메모하기", style: .default) { (_)  in
            let memo = alert.textFields?[0].text
            //값 저장
            ud.set(memo, forKey: "memo\(indexPath.row+1)")
            tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        let delete = UIAlertAction(title: "메모지우기", style: .destructive) { (_) in
           
            let memo: String? = nil
            
            ud.set(memo, forKey: "memo\(indexPath.row+1)")
            tableView.reloadData()
        }
        alert.addAction(add)
        alert.addAction(cancel)
        alert.addAction(delete)
        
        //텍스트필드 추가
        alert.addTextField { (tf) in
                tf.placeholder = "메모를 입력해주세요"
                tf.isSecureTextEntry = false
        }
        self.present(alert, animated: false)
        
    }
    

}

