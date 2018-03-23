//
//  WorldStoriDetails.swift
//  DashStori
//
//  Created by QBurst on 22/09/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import MapKit

class WorldStori:BaseResponseModel, MKAnnotation {
    var latitude:Float = 0
    var longitude:Float = 0
    var storiId:Int = 0
    var thumbImage:String = ""
    
    var title:String? = ""
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        storiId <- map["stori_id"]
        thumbImage <- map["thumb_image"]
        title <- map["title"]
        
        coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                            longitude: CLLocationDegrees(longitude))
        
        super.mapping(map: map)
    }
    
    required convenience init?(map: Map){
        self.init()
    }
}

class WorldStoriDetails: BaseResponseModel {
    
    var data:[WorldStori] = []

    override func mapping(map: Map) {
        data <- map["data"]
        super.mapping(map: map)
    }
    
    required convenience init?(map: Map){
        self.init()
    }
}
