//
//  UrlDetails.swift
//  DashStori
//
//  Created by George on 10/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class UrlDetails: BaseResponseModel {

    var URL:String = ""
    var id:Int = 0
    var newURL:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        URL <- map["url"]
        id <- map["id"]
        newURL <- map["data"]
        super.mapping(map: map)
    }
}

class VideoUrlDetails: UrlDetails {
    
    required convenience init?(map: Map) {
        self.init()
    }

    override func mapping(map: Map) {
        URL <- map["video_url"]
        id <- map["id"]
        newURL <- map["data"]
        super.mapping(map: map)
    }
}

class LinkUrlDetails: UrlDetails {
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        URL <- map["link_url"]
        id <- map["id"]
        newURL <- map["data"]
        super.mapping(map: map)
    }
}
