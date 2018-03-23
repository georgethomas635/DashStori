//
//  DeleteStoriRequest.swift
//  DashStori
//
//  Created by George on 11/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class DeleteStoriRequest: BaseAPI {

    var storiID:Int = 0
    
    override func getMethod() -> HTTPMethod {
        return .delete
    }
    override func getUrl() -> String {
        return BASE_URL + DELETE_STORI + String(storiID)
    }
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    func deleteStori(storiId:Int, and completion: @escaping RequestCompletion){
        self.storiID = storiId
        performRequest(parameter: nil, completion: completion)
    }
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject:response)
    }
}
