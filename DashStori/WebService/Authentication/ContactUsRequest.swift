//
//  ContactUsRequest.swift
//  DashStori
//
//  Created by George on 16/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper

class ContactUsRequest: BaseAPI {

    override func getUrl() -> String {
        return BASE_URL + CONTACTUS
    }
    
    func contactUs(request:ContactUsRequestModel, and completion: @escaping RequestCompletion) {
        let param = request.toJSON()
        performRequest(parameter: param, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject:response)
    }
    
}
