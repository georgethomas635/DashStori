//
//  ListOfStoriesResponse.swift
//  DashStori
//
//  Created by George on 06/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class ListOfStoriesResponse: BaseResponseModel {
    
    var data:[StoriDetailsList] = []
    var isMystori:Bool = false
    var totalPages:Int = 0
    
    
    override func mapping(map: Map) {
        data <- map["data"]
        isMystori <- map["is_mystori"]
        totalPages <- map["number_of_pages"]
        super.mapping(map: map)
    }
    
    required convenience init?(map: Map){
        self.init()
    }

}
