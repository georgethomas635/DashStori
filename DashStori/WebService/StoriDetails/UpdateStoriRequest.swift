//
//  UpdateStoriRequest.swift
//  DashStori
//
//  Created by George on 11/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class UpdateStoriRequest: BaseAPI {

    var storiID:Int = 0
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
    override func getUrl() -> String {
        return BASE_URL + UPDATESTORI + String(storiID)
    }
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    func updateStori(storiId:Int,details:EditStoriDetails, and completion: @escaping RequestCompletion){
        self.storiID = storiId
        let params = details.toJSON()
        performRequest(parameter: params, completion: completion)
    }
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<EditStoriResponse>().map(JSONObject:response)
    }
}
