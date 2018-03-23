//
//  LogoutRequest.swift
//  DashStori
//
//  Created by George on 18/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class LogoutRequest: BaseAPI {
    
    override func getUrl() -> String {
        return BASE_URL + LOGOUT
    }
    
    func logoutAPICall(completion: @escaping RequestCompletion){
        let request = BaseMapableModel()
        let param = request.toJSON()
        performRequest(parameter: param, completion: completion)
    }
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject: response)
    }
}
