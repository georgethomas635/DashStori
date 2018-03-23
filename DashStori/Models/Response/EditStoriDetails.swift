//
//  EditStoriDetails.swift
//  DashStori
//
//  Created by George on 10/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class EditStoriDetails: BaseResponseModel {

    var firstName:String = ""
    var middleName:String = ""
    var lastName:String = ""
    var dateOfBirth:String = ""
    var dateOfDeath:String? = nil
    var storyDetails:String = ""
    var location:[Location] = []
    var imageList:[UrlDetails] = []
    var videoList:[VideoUrlDetails] = []
    var linkList:[LinkUrlDetails] = []
    var coverPic :[UrlDetails] = []
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
        location <- map["locations"]
        
        imageList <- map["images"]

        linkList <- map["links"]

        videoList <- map["videos"]
        
        coverPic <- map["cover_pic"]
        saveAsDraft <- map["draft"]
        super.mapping(map: map)
    }
    
}
