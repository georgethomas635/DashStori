//
//  UpdateProfileRequest.swift
//  DashStori
//
//  Created by George on 12/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class UpdateProfileRequest: BaseAPI {

    override func getUrl() -> String {
        return BASE_URL + UPDATE_PROFILE
    }
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    
    func updateUserDetails(request:UpdateProfileRequestModel, and completion: @escaping RequestCompletion){
        let param = request.toJSON()
        performRequest(parameter: param, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<LoginResponseModel>().map(JSONObject:response)
    }
}
