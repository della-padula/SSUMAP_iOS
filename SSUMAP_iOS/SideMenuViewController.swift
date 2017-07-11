//
//  SideMenuViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 11..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit

class SideMenuViewController : UIViewController {
    
    @IBAction func sendMail(_ sender: Any) {
        let email = "gydect48@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}
