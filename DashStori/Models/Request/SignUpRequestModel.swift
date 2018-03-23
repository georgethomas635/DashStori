//
//  signUpRequestModel.swift
//  DashStori
//
//  Created by George on 24/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class SignUpRequestModel: BaseMapableModel {

    var email:String = ""
    var password:String = ""
    var firstName:String = ""
    var lastName:String = ""
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        super.mapping(map: map)
    }
}
