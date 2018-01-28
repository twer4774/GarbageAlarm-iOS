//
//  ETCViewController.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 9..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit

class ETCViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet var etcWebView: UIWebView!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    func loadWebPage(_ url: String){
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        etcWebView.loadRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebPage("http://waste.jejusi.go.kr/index.php/wainfo")
        etcWebView.scalesPageToFit = true
        etcWebView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sgChangeMenu(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //분리수거 배출안내
            loadWebPage("http://waste.jejusi.go.kr/index.php/wainfo")
        case 1:
            //대형폐기물 배출신청
            loadWebPage("http://waste.jejusi.go.kr/index.php/request")
        case 2:
            //대형폐기물 수수료
            loadWebPage("http://waste.jejusi.go.kr/index.php/payment")
        default:
            //분리수거 배출안내
            loadWebPage("http://waste.jejusi.go.kr/index.php/wainfo")
        }
        
    
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {        
        myActivityIndicator.stopAnimating()
    }
    
    

}
