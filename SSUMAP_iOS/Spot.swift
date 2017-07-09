//
//  Spot.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 6..
//  Copyright © 2017년 Personal. All rights reserved.
//

import Foundation

class Spot {
    var name : String?
    var address : String?
    var description : String?
    var latitude : Double
    var longitude : Double
    var categoryIndex : Int
    var fileURL : String?
    var phoneNumber : String?
    
    init(_ name: String, _ address : String, _ description : String, _ latitude : Double, _ longitude : Double, _ categoryIndex : Int, _ fileURL : String, _ phoneNumber : String) {
        self.name = name
        self.address = address
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.categoryIndex = categoryIndex
        self.fileURL = fileURL
        self.phoneNumber = phoneNumber
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getAddress() -> String {
        return self.address!
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
    
    func getCategoryIndex() -> Int {
        return self.categoryIndex
    }
    
    func getFileUrl() -> String {
        return self.fileURL!
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber!
    }
}
