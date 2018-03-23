//
//  VideoThumbnail.swift
//  DashStori
//
//  Created by George on 08/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class VideoThumbnail: BaseResponseModel {
    
    var videoURL:String = ""
    var thumbnail:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        videoURL <- map["video_url"]
        thumbnail <- map["thumb_url"]
        super.mapping(map: map)
    }

}
