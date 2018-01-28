//
//  LicenceViewController.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 9..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit

class LicenceViewController: UIViewController {

    @IBOutlet var lbLicnece: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lbLicnece.numberOfLines = 0
        lbLicnece.text = "본 어플리케이션에 사용된 아이콘은 The Recycling Partnership의 Free for commercial use license의 허가 아래 사용 되었습니다. \n\n본 어플리케이션에 사용된 아이콘은 Flation의 Freepik가 제작하였습니다."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
