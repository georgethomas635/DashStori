//
//  EditStoriResponse.swift
//  DashStori
//
//  Created by George on 10/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class EditStoriResponse: BaseResponseModel {
    
    var storiData:EditStoriDetails?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        storiData <- map["data"]
        super.mapping(map: map)
    }
}
