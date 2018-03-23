//
//  ListOfStoriesResponse.swift
//  DashStori
//
//  Created by George on 06/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class StoriDetailsList: BaseResponseModel {

    var videoCount:Int = 0
    var publishedOn:String = ""
    var authorName:String = ""
    var authorPicUrl:String!
    var storiTitle:String = ""
    var docCount:Int = 0
    var storiDescription:String?
    var coverPic:String = ""
    var storiId:Int = 0
    var imageCount:Int = 0
    var isDraft:Bool = false
    var verified:Bool = false
    
    override func mapping(map: Map) {
        videoCount <- map["video_count"]
        publishedOn <- map["published_on"]
        storiTitle <- map["title"]
        authorName <- map["auhtor"]
        docCount <- map["doc_count"]
        storiDescription <- map["stori"]
        coverPic <- map["cover_image"]
        storiId <- map["stori_id"]
        imageCount <- map["image_count"]
        authorPicUrl <- map["author_pic"]
        isDraft <- map["draft"]
        verified <- map["verified"]
        super.mapping(map: map)
    }
    
    required convenience init?(map: Map){
        self.init()
    }
}
