//
//  AuthorDetailsResponseModel.swift
//  DashStori
//
//  Created by George on 02/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class AuthorDetailsModel: BaseResponseModel {
    
    var authorDetails:UserDetailsModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        authorDetails <- map["data"]
        super.mapping(map: map)
    }
}
