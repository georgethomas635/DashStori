//
//  LoginRequest.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginRequest: BaseAPI {
    
    override func getUrl() -> String {
        return BASE_URL + LOGIN
    }
    
    func loginRequest(request:LoginRequestModel, and completion: @escaping RequestCompletion) {
        let param = request.toJSON()
        performRequest(parameter: param, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {        
        return Mapper<LoginResponseModel>().map(JSONObject:response)
    }
    
}
