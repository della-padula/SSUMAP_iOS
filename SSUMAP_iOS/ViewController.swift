//
//  ViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 6. 30..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

enum Location {
    case startLocation
    case destinationLocation
}

class ViewController: UIViewController, CLLocationManagerDelegate, MTMapViewDelegate  {
    
    @IBOutlet weak var daumMapView: MTMapView!
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var cur_longitude : Double = 126.959577
    var cur_latitude : Double = 37.494944
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func surroundingButton(_ sender: Any) {
                guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "surroundingVC") as? SurroundingViewController else {
                    return
                }
                self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    //캠퍼스 투어 버튼
    @IBAction func routeButton(_ sender: Any) {
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "campusTourVC") as? CampusTourViewController else {
            return
        }
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func curLocationButton(_ sender: Any) {
        self.daumMapView.setZoomLevel(0, animated: true)
        self.daumMapView.setMapCenter(
            MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: self.cur_latitude,
                                                         longitude: self.cur_longitude))  , animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        
        //print(latestLocation.coordinate.latitude)
        //print(latestLocation.coordinate.longitude)
        
        self.cur_longitude = latestLocation.coordinate.longitude
        self.cur_latitude = latestLocation.coordinate.latitude
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(latestLocation as! CLLocation) {
            (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0 {
                //let placemark = placemarks[0]
                //print(placemark)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("GPS Error => \(error.localizedDescription)")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 애플리케이션의 위치 추적 허가 상태가 변경될 경우 호출
        print("위치 허가 상태 변경됨")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "홈"
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.daumMapView.delegate = self
        self.daumMapView.daumMapApiKey = "a6f6c230d7322afcfc70727168b0b001"
        self.daumMapView.baseMapType = .standard
        self.daumMapView.setZoomLevel(0, animated: true)
        self.daumMapView.setMapCenter(
            MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: self.cur_latitude,
                                                         longitude: self.cur_longitude))  , animated: true)
        
        self.daumMapView.currentLocationTrackingMode = .onWithoutHeading
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

