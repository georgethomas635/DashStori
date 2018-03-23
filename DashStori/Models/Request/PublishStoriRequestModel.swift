//
//  PublishStoriRequest.swift
//  DashStori
//
//  Created by George on 31/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class PublishStoriRequestModel: BaseMapableModel {

    var firstName:String = ""
    var middleName:String = ""
    var lastName:String = ""
    var dateOfBirth:String? = nil
    var dateOfDeath:String? = nil
    var storyDetails:String = ""
    var linkUrl:[UrlDetails]?
    var videoUrl:[UrlDetails]?
    var coverPic = UrlDetails()
    var images:[UrlDetails]?
    var location:[Location] = []
    var saveAsDraft:Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        firstName <- map["first_name"]
        middleName <- map["middle_name"]
        lastName <- map["last_name"]
        dateOfBirth <- map["dob"]
        dateOfDeath <- map["dod"]
        storyDetails <- map["stori"]
        linkUrl <- map["links"]
        videoUrl <- map["videos"]
        coverPic <- map["cover_pic"]
        images <- map["images"]
        location <- map["locations"]
        saveAsDraft <- map["draft"]
        super.mapping(map: map)
    }
}
