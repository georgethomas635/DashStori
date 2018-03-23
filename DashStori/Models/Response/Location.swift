//
//  Location.swift
//  DashStori
//
//  Created by George on 04/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import GooglePlaces

class Location: BaseMapableModel {
    
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        super.mapping(map: map)
    }
}
