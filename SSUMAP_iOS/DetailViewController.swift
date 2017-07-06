//
//  DetailViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 6..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit
import Kanna
import Kingfisher

class DetailViewController : UIViewController {
    var vcTitle : String?
    var spotItem : Spot?
    @IBOutlet weak var spotNameText: UILabel!
    @IBOutlet weak var spotDistanceText: UILabel!
    @IBOutlet weak var spotAddressText: UILabel!
    @IBOutlet weak var spotDescriptionText: UILabel!
    @IBOutlet weak var spotImage: UIImageView!
    
    override func viewDidLoad() {
        self.title = self.vcTitle
        self.spotNameText.text = spotItem?.getName()
        self.spotAddressText.text = spotItem?.getAddress()
        self.spotDescriptionText.text = spotItem?.getDescription()
        
        print(ApiURL.hostURL + "/files/" + (spotItem?.getFileUrl())!)
        let pic_url = URL(string: (ApiURL.hostURL + "/files/" + (spotItem?.getFileUrl())!))
        self.spotImage.kf.setImage(with: pic_url)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
}
