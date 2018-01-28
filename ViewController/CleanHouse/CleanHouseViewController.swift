//
//  CleanHouseViewController.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 1..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit
import MapKit
import GoogleMobileAds

class CleanHouseViewController: UIViewController, NMapViewDelegate, NMapPOIdataOverlayDelegate, NMapLocationManagerDelegate, XMLParserDelegate, GADBannerViewDelegate{
    
    var bannerView: GADBannerView!

    var mapView: NMapView?
    
    @IBOutlet var myMapView: UIView!
    var changeStateButton: UIButton?
    
    var myLongitude: Double = 0.0
    var myLatitude: Double = 0.0
    
    var minLongitude: Double = 0.0
    var maxLongitude: Double = 0.0
    var minLatitude: Double = 0.0
    var maxLatitude: Double = 0.0
    
    let cleanHM = CleanHouseModel()
    
    @IBOutlet var calloutView: UIView!
    @IBOutlet var calloutLabel: UILabel!
    
    var address = ""
    var dong = ""
    var location = ""
    var mapx = ""
    var mapy = ""
    
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentState: state = .disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        mapView = NMapView(frame: myMapView.bounds)
        
        
        if let mapView = mapView {
            mapView.delegate = self
            
            mapView.setClientId("YourID")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            view.addSubview(mapView)
        }
        
        //지도를 정밀하게 표시해줌
        mapView?.setMapEnlarged(true, mapHD: true)
        
        // Add Controls.
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            view.addSubview(button)
        }
        
        getAPI()
        //현재 위치 표시
        if let lm = NMapLocationManager.getSharedInstance() {
            // set delegate
            lm.setDelegate(self)
            
            // start updating location
            lm.startContinuousLocationInfo()
            getAPI()
            
            mapView?.setAutoRotateEnabled(true, animate: true)
            
            // start updating heading
//            lm.startUpdatingHeading()
            
            //내 위치 중심으로 클린하우스 표시
            myLatitude = (lm.locationManager.location?.coordinate.latitude)!
            myLongitude = (lm.locationManager.location?.coordinate.longitude)!
            print(myLatitude)
            
            minLongitude = myLongitude - 0.002
            maxLongitude = myLongitude + 0.002
            
            minLatitude = myLatitude - 0.002
            maxLatitude = myLatitude + 0.002
        }
        
        //지도를 정밀하게 표시해줌
        mapView?.setMapEnlarged(true, mapHD: true)
        
        // Add Controls.
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            view.addSubview(button)
        }
        
        
        //공공데이터 불러오기
        getAPI()
 

        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if view.frame.size.width != size.width {
            if let mapView = mapView, mapView.isAutoRotateEnabled {
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.mapView {
                        mapView.setAutoRotateEnabled(true, animate: false)
                    }
                }, completion: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        mapView?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.viewDidDisappear()
    }
    
    // MARK: - NMapViewDelegate Methods
    
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        
        //        if (error == nil) { // success
        //            // set map center and level
        //            mapView.setMapCenter(NGeoPoint(longitude:126.978371, latitude:37.5666091), atLevel:11)
        //
        //            // set for retina display
        //            mapView.setMapEnlarged(true, mapHD: true)
        //            // set map mode : vector/satelite/hybrid
        //            mapView.mapViewMode = .vector
        //        } else { // fail
        //            print("onMapView:initHandler: \(error.description)")
        //        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "YourID"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getAPI()
        mapView?.viewDidAppear()
        
        //        showMarkers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView?.viewWillDisappear()
        
        stopLocationUpdating()
    }
    
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        calloutLabel.text = poiItem.title
        
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
        return calloutView
    }

    // MARK: - NMapLocationManagerDelegate Methods
    
    open func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        
        myLatitude = myLocation.latitude
        myLongitude = myLocation.longitude
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
        
    }
    
    open func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
            
        }
    getAPI()
    
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
    
    func getAPI(){
        var parser = XMLParser()
        let url = "http://openapi.jejusi.go.kr/rest/cleanhouseinfoservice/getCleanHouseInfoList?serviceKey=YourServiceKey&pageNo=1&startPage=1&numOfRows=1877&pageSize=1877"
        
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
    }
    //parser가 시작태그를 만나면 호출
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        cleanHM.currentElement = elementName
        
        if elementName == "list" {
            address = ""
            dong = ""
            location = ""
            mapx = ""
            mapy = ""
        }
    }
    
    //parser가 닫는 태그를 만나면 호출
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        cleanHM.currentElement = ""
        
        if elementName == "list" {
            cleanHM.address = address
            cleanHM.dong = dong
            cleanHM.location = location
            cleanHM.mapx = mapx
            cleanHM.mapy = mapy
            
            if let mapOverlayManager = mapView?.mapOverlayManager {
                
                // create POI data overlay
                if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                    
                    poiDataOverlay.initPOIdata(1877)
                    
                    if let long: Double = Double("\(cleanHM.mapy)"), let lati: Double = Double("\(cleanHM.mapx)") {
                        if(long >= minLongitude && long <= maxLongitude && lati >= minLatitude && lati <= maxLatitude){
                            poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: long, latitude:  lati), title: "\(cleanHM.location)", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                        }
                    }
                    
                    poiDataOverlay.endPOIdata()
                    
                    // show all POI data
                    poiDataOverlay.showAllPOIdata()
                    poiDataOverlay.selectPOIitem(at: 2, moveToCenter: false, focusedBySelectItem: true)
                }
            }
        }
    }
    
    //현재 태그에 담겨 있는 string 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //        if(passName){
        //            strXMLData = strXMLData + "\n\n"+string
        //        }
        let eName = cleanHM.currentElement
        
        if eName == "address"{
            address = address + string
        } else if eName == "dong" {
            dong = dong + string
        } else if eName == "location" {
            location = location + string
        } else if eName == "mapx"{
            mapx = mapx + string
        } else if eName == "mapy"{
            mapy = mapy + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
}



