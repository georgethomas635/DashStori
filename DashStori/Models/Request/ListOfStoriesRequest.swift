//
//  ListOfStoriesRequest.swift
//  DashStori
//
//  Created by George on 06/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class ListOfStoriesRequest: BaseMapableModel {
    
    var page:Int = 0
    var myStori:Int = 0

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        page <- map["page"]
        myStori <- map["mystori"]
        super.mapping(map: map)
    }

}
