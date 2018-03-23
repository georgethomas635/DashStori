//
//  ContactUsRequestModel.swift
//  DashStori
//
//  Created by George on 16/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class ContactUsRequestModel: BaseMapableModel {

    var name:String = ""
    var email:String = ""
    var phoneNumber:String = ""
    var message:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        phoneNumber <- map["phone"]
        message <- map["message"]
        super.mapping(map: map)
    }
}
