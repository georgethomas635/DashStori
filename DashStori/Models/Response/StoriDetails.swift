//
//  StoriDetailsResponse.swift
//  DashStori
//
//  Created by George on 20/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class StoriDetails: BaseResponseModel {

    var storiTitle:String = ""
    var dateOfBirth:String = ""
    var dateOfDeath:String = ""
    var storyDetails:String = ""
    var linkUrl:[String] = []
    var videoUrl:[VideoThumbnail] = []
    var images:[String] = []
    var authorID:Int = 0
    var authorName:String = ""
    var authorPicUrl:String = ""
    var location:[Location] = []
    var isMyStori:Bool = false
    var listOfDocuments:[StoriDocuments] = []
    var reported:Bool = false
    var verified:Bool = false
    var publishedOn:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        dateOfBirth <- map["dob"]
        dateOfDeath <- map["dod"]
        storyDetails <- map["stori"]
        linkUrl <- map["links"]
        videoUrl <- map["videos"]
        images <- map["images"]
        storiTitle <- map["title"]
        authorID <- map["author_id"]
        location <- map["locations"]
        isMyStori <- map["my_stori"]
        listOfDocuments <- map["docs"]
        reported <- map["reported"]
        verified <- map["verified"]
        authorName <- map["author_name"]
        authorPicUrl <- map["author_image"]
        publishedOn <- map["published_on"]
        super.mapping(map: map)
    }

}
