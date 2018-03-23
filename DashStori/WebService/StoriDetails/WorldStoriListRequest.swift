//
//  WorldStoriListRequest.swift
//  DashStori
//
//  Created by QBurst on 22/09/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class WorldStoriListRequest: BaseAPI {
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
    override func getUrl() -> String {
        return BASE_URL + STORIS_AROUND_ME
    }
    
    func worldStories(request:WorldStoriListRequest , and completion: @escaping RequestCompletion){
        performRequest(parameter: nil, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<WorldStoriDetails>().map(JSONObject:response)
    }
}
