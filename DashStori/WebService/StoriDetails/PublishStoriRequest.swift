//
//  PublishStoriRequest.swift
//  DashStori
//
//  Created by George on 31/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class PublishStoriRequest: BaseAPI {

    override func getMethod() -> HTTPMethod {
        return .post
    }
    override func getUrl() -> String {
        return BASE_URL + PUBLISH_STORI
    }
    
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    
    func publishStori(request: PublishStoriRequestModel, and completion: @escaping RequestCompletion){
        let param = request.toJSON()
//        print("Request :",param)
        performRequest(parameter: param, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject:response)
    }
}
