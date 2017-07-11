import UIKit
import Kanna
import Alamofire
import CoreLocation
import Kingfisher

extension UIButton {
    func alignVertical(spacing: CGFloat = 3.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset * 0.7, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

class DetailViewController : UIViewController, CLLocationManagerDelegate {
    var vcTitle : String?
    var spotItem : Spot?
    var start_lat : Double?
    var start_lon : Double?
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var cur_longitude : Double?
    var cur_latitude : Double?
    
    var token = "e635c063-5164-347e-b787-dfd91da1d275"
    var loadingView: UIView = UIView()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    @IBOutlet weak var spotNameText: UILabel!
    @IBOutlet weak var spotDistanceText: UILabel!
    @IBOutlet weak var spotAddressText: UILabel!
    @IBOutlet weak var spotDescriptionText: UILabel!
    
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet var spotCallText: UILabel!
    
    @IBOutlet var spotCallBtn: UIButton!
    @IBOutlet var spotShareBtn: UIButton!
    @IBOutlet var spotRouteBtn: UIButton!
    
    
    @IBAction func callButtonAction(_ sender: Any) {
        let result_phone = spotItem?.getPhoneNumber().replace(target: "-", withString: "")
        
        guard let number = URL(string: "tel://" + result_phone!) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func routeButtonAction(_ sender: Any) {
        //daummaps://route?sp=37.537229,127.005515&ep=37.4979502,127.0276368&by=FOOT
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let personRoute = UIAlertAction(title: "보행자 길찾기", style: .default) { (alert : UIAlertAction!) in
            self.openDaumMapRoute(1)
        }
        
        let carRoute = UIAlertAction(title: "자동차 길찾기", style: .default) { (alert : UIAlertAction!) in
            self.openDaumMapRoute(2)
        }
        
        let transRoute = UIAlertAction(title: "대중교통 길찾기", style: .default) { (alert : UIAlertAction!) in
            self.openDaumMapRoute(3)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (alert : UIAlertAction!) in
            
        }
        
        optionMenu.addAction(personRoute)
        optionMenu.addAction(carRoute)
        optionMenu.addAction(transRoute)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let shareContent = self.spotNameText.text! + "/" + self.spotAddressText.text! + "/" + self.spotCallText.text!
        displayShareSheet(shareContent: shareContent)
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func openDaumMapRoute(_ option : Int) {
        var daummapHooks : String?
        
        if option == 1 {
            daummapHooks = "daummaps://route?sp=\(self.cur_latitude!),\(self.cur_longitude!)&ep=\(spotItem!.getLatitude()),\(spotItem!.getLongitude())&by=FOOT"
        } else if option == 2 {
            daummapHooks = "daummaps://route?sp=\(self.cur_latitude!),\(self.cur_longitude!)&ep=\(spotItem!.getLatitude()),\(spotItem!.getLongitude())&by=CAR"
        } else if option == 3 {
            daummapHooks = "daummaps://route?sp=\(self.cur_latitude!),\(self.cur_longitude!)&ep=\(spotItem!.getLatitude()),\(spotItem!.getLongitude())&by=PUBLICTRANSIT"
        }
        
        let daummapUrl = URL(string: daummapHooks!)
        if UIApplication.shared.canOpenURL(daummapUrl! as URL)
        {
            UIApplication.shared.open(daummapUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%EB%A7%B5-%EB%8B%A4%EC%9D%8C%EC%A7%80%EB%8F%84-4-0/id304608425?mt=8")!)
        }
    }
    
    override func viewDidLoad() {
        self.title = self.vcTitle
        
        self.cur_latitude = self.start_lat!
        self.cur_longitude = self.start_lon!
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.spotNameText.text = spotItem?.getName()
        self.spotAddressText.text = spotItem?.getAddress()
        self.spotDescriptionText.text = spotItem?.getDescription()
        
        print(ApiURL.hostURL + "/files/" + (spotItem?.getFileUrl())!)
        let pic_url = URL(string: (ApiURL.hostURL + "/files/" + (spotItem?.getFileUrl())!).encodeUrl())
        self.spotImage.kf.setImage(with: pic_url)
        self.spotCallText.text = spotItem?.getPhoneNumber()
        
        self.spotShareBtn.imageView?.contentMode = .scaleAspectFit
        self.spotRouteBtn.imageView?.contentMode = .scaleAspectFit
        self.spotCallBtn.imageView?.contentMode = .scaleAspectFit
        
        self.spotRouteBtn.alignVertical()
        self.spotCallBtn.alignVertical()
        self.spotShareBtn.alignVertical()
        self.getDistance()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func getDistance() {
        let parameters : Parameters = [
            "startX" : self.start_lon!,
            "startY" : self.start_lat!,
            "endX" : spotItem!.getLongitude(),
            "endY" : spotItem!.getLatitude(),
            "reqCoordType" : "WGS84GEO",
            "startName" : spotItem!.getName().encodeUrl(),
            "endName" : spotItem!.getName().encodeUrl() 
        ]
        
        let headers : HTTPHeaders = [
            "appKey" : self.token,
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        
        //method: .post
        Alamofire.request("https://apis.skplanetx.com/tmap/routes/pedestrian?version=1", method: .post, parameters: parameters, headers: headers).responseJSON {
            response in
            
            if let result = response.result.value as? [String: Any] {
                if let items = result["features"] as? [[String: Any]] {
                    if let item = items[0]["properties"] as? [String: Any] {
                        let dist = item["totalDistance"] as! Double
                        let time = item["totalTime"] as! Int
                        
                        let numberOfPlaces = 1.0
                        let multiplier = pow(10.0, numberOfPlaces)
                        let dist_double = dist / 1000.0
                        
                        let rounded = round(dist_double * multiplier) / multiplier
                        
                        self.spotDistanceText.text = "\(rounded)km"
//                        }
                        
                        let (hour, minute, second) = self.secondsToHoursMinutesSeconds(seconds: time)
                        let hourText = hour > 0 ? "\(hour)시간" : ""
                        let minText = minute > 0 ? "\(minute)분" : ""
                        let secText = second > 0 ? "1분" : "0분"
                        
                        print(hourText + minText + secText)
                    }
                }
            }
        }
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
                //let placemark = placemarks[0]
                //print(placemark)
            }
        }
        
        self.getDistance()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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
