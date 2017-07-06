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

class SpotListViewController : UIViewController, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var categoryIndex : Int?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var googleMapView: GMSMapView!
    
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.title = self.vcTitle!
        
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
        
        loadList(inputCategoryIndex: self.categoryIndex!, inputPage: self.page, inputTake: self.take)
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else {
            return
        }
        nextView.vcTitle = self.selectedName
        nextView.spotItem = self.elements[selectedIndex!]
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.googleMapView.clear()
        selectedName = elements[indexPath.row].getName()
        selectedIndex = indexPath.row
        showMarkerToMap(lat: elements[indexPath.row].getLatitude(), lon: elements[indexPath.row].getLongitude(), name: elements[indexPath.row].getName())
        let camera = GMSCameraPosition.camera(withLatitude: elements[indexPath.row].getLatitude(), longitude: elements[indexPath.row].getLongitude(), zoom: 19.0)
        self.googleMapView.camera = camera
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        cell.spotNameText.text = elements[indexPath.row].getName()
        cell.selectionStyle = .none
        return cell
    }
    
    func showMarkerToMap(lat latitude : Double, lon longitude : Double, name nameSpot : String) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = nameSpot
        marker.snippet = "상세 정보 보기 >"
        marker.map = self.googleMapView
        marker.icon = UIImage(named: "map_marker")
        marker.tracksInfoWindowChanges = true
        
        self.googleMapView.selectedMarker = marker
    }
    
    func loadList(inputCategoryIndex categoryIndex: Int, inputPage page: Int, inputTake take: Int) {
        self.showActivityIndicator()
        Alamofire.request(ApiURL.hostURL + ApiURL.listURL + "?categoryIndex=\(categoryIndex)&page=\(page)&take=\(take)").responseJSON { response in
            
            if let result = response.result.value as? [[String: Any]] {
                self.hideActivityIndicator()
                if(result.count < 1) {
                    print("Count가 0입니다.")
                    
                    let no_account_dialog = UIAlertController(title: "장소 없음", message: "해당하는 장소가 없습니다.", preferredStyle: .alert)
                    
                    let no_account_action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    }
                    no_account_dialog.addAction(no_account_action)
                    
                    self.present(no_account_dialog, animated: true, completion: nil)
                    return
                }
                
                for i in 0..<result.count {
                    self.elements.append(Spot.init((result[i]["name"] as! String).replace(target: "+", withString: " ").decodeUrl(), (result[i]["address"] as! String).replace(target: "+", withString: " ").decodeUrl(), (result[i]["description"] as! String).replace(target: "+", withString: " ").decodeUrl(), result[i]["latitude"] as! Double, result[i]["longitude"] as! Double, categoryIndex, (result[i]["fileName"] as! String).replace(target: "+", withString: " ").decodeUrl()))
                }
                
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
}
