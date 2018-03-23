//
//  LoginResponseModel.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginResponseModel: BaseResponseModel {


    var userDetails:UserDetailsModel?
    var token:String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override func mapping(map: Map) {
        userDetails <- map["data"]
        token <- map["token"]
        super.mapping(map: map)
    }
}
