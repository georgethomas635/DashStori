//
//  StoriDocuments.swift
//  DashStori
//
//  Created by George on 18/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class StoriDocuments: BaseResponseModel {
    
    var docName:String = ""
    var url:String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        url <- map["url"]
        docName <- map["name"]
        super.mapping(map: map)
    }
}
