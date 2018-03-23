//
//  UpdateProfileRequestModel.swift
//  DashStori
//
//  Created by George on 12/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class UpdateProfileRequestModel: BaseMapableModel {
    
    var firstName:String = ""
    var middleName:String!
    var lastName:String = ""
    var email:String = ""
    var aboutUser:String!
    var profilePic:String!
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        middleName <- map["middle_name"]
        email <- map["email"]
        aboutUser <- map["description"]
        profilePic <- map["profile_image"]
        super.mapping(map: map)
    }
    
}
