//
//  BaseResponseModel.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseResponseModel: BaseMapableModel {
    
    var success:Bool = true
    var errors:String = ""
    var message:String = ""
    

    override func mapping(map: Map) {
        success <- map["Success"]
        errors <- map["errors"]
        message <- map["Message"]
        super.mapping(map: map)
    }
    
}
