//
//  BaseMapableModel.swift
//  BaseProjectStructure
//
//  Created by Amruthaprasad on 22/01/16.
//  Copyright © 2016 Amruthaprasad. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseMapableModel: NSObject, Mappable {
    
    var fromMobileFlag = true
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        fromMobileFlag <- map["is_fromMobile"]
    }
    
    convenience override init() {
        self.init(args: nil)
        
    }
    
    init(args: Any?) {
        super.init()
    }
 }
