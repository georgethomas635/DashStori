//
//  UserDetailsModel.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class UserDetailsModel: BaseMapableModel {

    var firstName:String = ""
    var lastName:String = ""
    var email:String = ""
    var middleName:String = ""
    var imageUrl:String = ""
    var totalStories:Int = 0
    var userDescription:String = ""
    var userId:Int?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override func mapping(map: Map) {
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        middleName <- map["middle_name"]
        imageUrl <- map["image"]
        totalStories <- map["total_stories"]
        userDescription <- map["description"]
        userId <- map["id"]
        super.mapping(map: map)
    }
}
