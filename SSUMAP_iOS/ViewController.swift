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

let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"poi.business\"," +
    "    \"elementType\": \"all\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit\"," +
    "    \"elementType\": \"labels.icon\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }" +
"]"

enum Location {
    case startLocation
    case destinationLocation
}

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
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
        
    }
    
    @IBAction func routeButton(_ sender: Any) {
        
    }
    
    @IBAction func curLocationButton(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: self.cur_latitude, longitude: self.cur_longitude, zoom: 17.0)
        self.googleMapView.camera = camera
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        
        print(latestLocation.coordinate.latitude)
        print(latestLocation.coordinate.longitude)
        
        self.cur_longitude = latestLocation.coordinate.longitude
        self.cur_latitude = latestLocation.coordinate.latitude
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(latestLocation as! CLLocation) {
            (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                print(placemark)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS Error => \(error.localizedDescription)")
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
        
        //37.494944, 126.959577
        let camera = GMSCameraPosition.camera(withLatitude: self.cur_latitude, longitude: self.cur_longitude, zoom: 17.0)
        
        self.googleMapView.delegate = self
        self.googleMapView.camera = camera
        self.googleMapView?.isMyLocationEnabled = true
        self.googleMapView.settings.myLocationButton = false
        self.googleMapView.settings.compassButton = true
        self.googleMapView.settings.zoomGestures = true
        
        do {
            self.googleMapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.494944, longitude: 126.959577)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.googleMapView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

