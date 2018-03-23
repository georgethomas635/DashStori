//
//  SignUpResponseModel.swift
//  DashStori
//
//  Created by George on 24/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class SignUpResponseModel: BaseResponseModel {

//    var userDetails:UserDetailsModel?
    var verificationMessage:String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override func mapping(map: Map) {
//        userDetails <- map["data"]
        verificationMessage <- map["data"]
        super.mapping(map: map)
    }
}
