//
//  SpotListViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 6..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Alamofire
import Kanna

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

class SpotListViewController : UIViewController, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MTMapViewDelegate {
    var categoryIndex : Int?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var daumMapView: MTMapView!
    
    var cur_longitude : Double = 126.959577
    var cur_latitude : Double = 37.494944
    
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var page = 0
    var take = 30
    
    var vcTitle : String?
    
    var elements : [Spot] = []
    var selectedName : String?
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        self.elements.removeAll()
        
        self.loadList(inputCategoryIndex: categoryIndex!, inputPage: page, inputTake: take)
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.title = self.vcTitle!
        
        self.daumMapView.delegate = self
        self.daumMapView.daumMapApiKey = "a6f6c230d7322afcfc70727168b0b001"
        self.daumMapView.baseMapType = .standard
        self.daumMapView.setZoomLevel(-1, animated: true)
        self.daumMapView.setMapCenter(
            MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: self.cur_latitude,
                                                         longitude: self.cur_longitude))  , animated: true)
        self.daumMapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.daumMapView.removeAllPOIItems()
        
        selectedName = elements[indexPath.row].getName()
        selectedIndex = indexPath.row
        
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else {
            return
        }
        nextView.vcTitle = self.selectedName
        nextView.spotItem = self.elements[selectedIndex!]
        nextView.start_lat = self.cur_latitude
        nextView.start_lon = self.cur_longitude
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        cell.spotNameText.text = elements[indexPath.row].getName()
        cell.selectionStyle = .none
        cell.spotIcon.image = AppData.category_image_array[categoryIndex!]
        return cell
    }
    
    func showMarkersToMap() {
        var items = [MTMapPOIItem]()
        for i in self.elements {
            items.append(poiItem(name: i.getName(), latitude: i.getLatitude(), longitude: i.getLongitude()))
        }
        
        self.daumMapView.addPOIItems(items)
        self.daumMapView.fitAreaToShowAllPOIItems()
    }
    
    func loadList(inputCategoryIndex categoryIndex: Int, inputPage page: Int, inputTake take: Int) {
        self.showActivityIndicator()
        Alamofire.request(ApiURL.hostURL + ApiURL.listURL + "?categoryIndex=\(categoryIndex)&page=\(page)&take=\(take)").responseJSON { response in
            
            if let result = response.result.value as? [[String: Any]] {
                self.hideActivityIndicator()
                if(result.count < 1) {
                    print("Count가 0입니다.")
                    return
                }
                
                for i in 0..<result.count {
                    self.elements.append(Spot.init((result[i]["name"] as! String).replace(target: "+", withString: " ").decodeUrl(), (result[i]["address"] as! String).replace(target: "+", withString: " ").decodeUrl(), (result[i]["description"] as! String).replace(target: "+", withString: " ").decodeUrl(), result[i]["latitude"] as! Double, result[i]["longitude"] as! Double, categoryIndex, (result[i]["fileName"] as! String).replace(target: "+", withString: " ").decodeUrl(), (result[i]["phoneNumber"] as! String)))
                }
                
                self.showMarkersToMap()
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.tableFooterView = UIView(frame: .zero)
                self.tableView.reloadData()
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = UIColor(hex: "707070")
            self.loadingView.alpha = 0.3
            self.loadingView.clipsToBounds = true
            self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)
            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
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
