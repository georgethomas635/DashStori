//
//  EditStoriRequest.swift
//  DashStori
//
//  Created by George on 10/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class EditStoriRequest: BaseAPI {
    var storiID:Int = 0
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
    override func getUrl() -> String {
        return BASE_URL + EDIT_STORI + String(storiID)
    }
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    func getStoriDetails(storiId:Int, and completion: @escaping RequestCompletion){
        self.storiID = storiId
        performRequest(parameter: nil, completion: completion)
    }
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<EditStoriResponse>().map(JSONObject:response)
    }
}
