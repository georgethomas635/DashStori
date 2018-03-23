//
//  SignUpRequest.swift
//  DashStori
//
//  Created by George on 24/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class SignUpRequest: BaseAPI {
    override func getUrl() -> String {
        return BASE_URL + SIGNUP
    }
    
    func signUp(request:SignUpRequestModel, and completion: @escaping RequestCompletion) {
        let param = request.toJSON()
        print(param)
        performRequest(parameter: param, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<SignUpResponseModel>().map(JSONObject:response)
    }
}
