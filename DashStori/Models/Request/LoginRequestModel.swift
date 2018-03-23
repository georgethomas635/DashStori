//
//  LoginRequestModel.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginRequestModel: BaseMapableModel {

    var email:String = ""
    var password:String = ""
    var accessToken = ""
    var method:String = ""

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        accessToken <- map["access_token"]
        method <- map["method"]
        super.mapping(map: map)
    }
}
