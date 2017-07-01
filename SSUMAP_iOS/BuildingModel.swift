//
//  BuildingModel.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 1..
//  Copyright © 2017년 Personal. All rights reserved.
//

import Foundation

class BuildingModel {
    private var buildingName : String?
    private var buildingCategory : Int
    private var buildingLatitude : Float
    private var buildingLongitude : Float
    private var buildingDescription : String?
    
    init(name: String?, category: Int, latitude: Float, longitude: Float, description: String?) {
        self.buildingName = name
        self.buildingCategory = category
        self.buildingLatitude = latitude
        self.buildingLongitude = longitude
        self.buildingDescription = description
    }
    
    func getBuildingName() -> String {
        return self.buildingName!
    }
    
    func getBuildingCategory() -> Int {
        return self.buildingCategory
    }
    
    func getBuildingLatitude() -> Float {
        return self.buildingLatitude
    }
    
    func getBuildingLongitude() -> Float {
        return self.buildingLongitude
    }
    
    func getBuildingDescription() -> String? {
        return self.buildingDescription!
    }
    
}
