//
//  CampusTourViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 9..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CampusTourViewController : UIViewController, MTMapViewDelegate {
    
    var cur_longitude : Double = 126.957570
    var cur_latitude : Double = 37.495850
    
    @IBOutlet var daumMap: MTMapView!
    
    @IBAction func startButton(_ sender: Any) {
        let no_account_dialog = UIAlertController(title: "준비중입니다", message: "해당 기능은 준비중입니다.", preferredStyle: .alert)
        
        let no_account_action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (alert : UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }
        no_account_dialog.addAction(no_account_action)
        
        self.present(no_account_dialog, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.title = "캠퍼스 투어"
        
        self.daumMap.delegate = self
        self.daumMap.daumMapApiKey = AppData.daumApiKey
        self.daumMap.baseMapType = .standard
        self.daumMap.setZoomLevel(1, animated: true)
        self.daumMap.setMapCenter(
            MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: self.cur_latitude,
                                                         longitude: self.cur_longitude))  , animated: true)
        
        //self.daumMap.currentLocationTrackingMode = .onWithoutHeading
        
        var mapPointList = [MTMapPoint]()
        var items = [MTMapPOIItem]()
        
        for item in AppData.campusTour {
            
            mapPointList.append(MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: item.getLatitude(), longitude: item.getLongitude())))
            
            items.append(poiItem(name: item.getName(), latitude: item.getLatitude(), longitude: item.getLongitude()))
            
        }
        
        let mtPolyLine = MTMapPolyline.polyLine()
        mtPolyLine?.polylineColor = UIColor(hex: "65B1D8")
        mtPolyLine?.addPoints(mapPointList)
        
        self.daumMap.addPolyline(mtPolyLine)
        self.daumMap.addPOIItems(items)
        //self.daumMap.fitAreaToShowAllPOIItems()
    }
    
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .bluePin
        item.markerSelectedType = .none
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        return item
    }
}
