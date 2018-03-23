//
//  StoriDetailsResponse.swift
//  DashStori
//
//  Created by George on 20/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class StoriDetailsResponse: BaseResponseModel {
    
    var storiData:StoriDetails?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        storiData <- map["data"]
        super.mapping(map: map)
    }
}
