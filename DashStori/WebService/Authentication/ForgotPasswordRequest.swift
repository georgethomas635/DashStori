//
//  ForgotPasswordRequest.swift
//  DashStori
//
//  Created by George on 17/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class ForgotPasswordRequest: BaseAPI {

    override func getUrl() -> String {
        return BASE_URL + FORGOT_PASSWORD
    }
    
    func forgotPasswordRequest(email:String, and completion: @escaping RequestCompletion) {
        let dic: [String: Any] = ["email": email]
//        let params

        performRequest(parameter: dic, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject:response)
    }
    
}
