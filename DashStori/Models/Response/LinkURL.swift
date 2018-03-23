//
//  LinkURL.swift
//  DashStori
//
//  Created by George on 24/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class LinkURL: BaseResponseModel {

    var URL:String = ""
    var id:Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        URL <- map["link_url"]
        id <- map["id"]
        super.mapping(map: map)
    }

}
