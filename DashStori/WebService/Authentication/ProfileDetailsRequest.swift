//
//  ProfileDetailsRequest.swift
//  DashStori
//
//  Created by George on 19/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ProfileDetailsRequest: BaseAPI {
    override func getUrl() -> String {
        return BASE_URL + UPDATE_PROFILE
    }
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
    
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    
    func getUserDetails(completion: @escaping RequestCompletion){
        performRequest(parameter: nil, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<LoginResponseModel>().map(JSONObject:response)
    }

}
