//
//  ViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 6. 30..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit
import MapKit
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func surroundingButton(_ sender: Any) {
        
    }
    
    @IBAction func routeButton(_ sender: Any) {
        
    }
    
    @IBAction func curLocationButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "홈"
        //37.494944, 126.959577
        let camera = GMSCameraPosition.camera(withLatitude: 37.494944, longitude: 126.959577, zoom: 17.0)
        
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

