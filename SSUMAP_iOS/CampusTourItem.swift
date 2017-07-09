//
//  CampusTourItem.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 9..
//  Copyright © 2017년 Personal. All rights reserved.
//

import Foundation

class CampusTourItem {
    var name : String?
    var latitude : Double
    var longitude : Double
    var description : String?
    
    init(_ name : String, _ latitude : Double, _ longitude : Double, _ description : String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getDescription() -> String {
        return self.description!
    }
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }
}
