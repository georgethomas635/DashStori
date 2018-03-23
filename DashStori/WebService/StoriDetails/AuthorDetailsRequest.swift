//
//  AuthorDetailsRequest.swift
//  DashStori
//
//  Created by George on 02/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class AuthorDetailsRequest: BaseAPI {

    var authorId:Int = 0
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
    override func getUrl() -> String {
        return BASE_URL + AUTHOR_DETAILS + String(authorId)
    }
    
//    override func getHeader() -> Dictionary<String, String>? {
//        var dict = Dictionary<String, String>()
//        dict["Authorization"] = "Token " + Utilities.getUserToken()!
//        return dict
//    }
    
    func getAuthorDetails(authorId:Int, and completion: @escaping RequestCompletion){
        self.authorId = authorId
        performRequest(parameter: nil, completion: completion)
    }
   
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<AuthorDetailsModel>().map(JSONObject:response)
    }
}
