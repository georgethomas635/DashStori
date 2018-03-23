//
//  StoriDetailsRequest.swift
//  DashStori
//
//  Created by George on 20/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class StoriDetailsRequest: BaseAPI {

    var storiID:Int = 0
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
    
    override func getUrl() -> String {
        return BASE_URL + STORI_DETAILS + String(storiID)
    }
    
    override func getHeader() -> Dictionary<String, String>? {
        
        let token:String = Utilities.getUserToken()
        if (token != "") {
            var dict = Dictionary<String, String>()
            dict["Authorization"] = "Token " + token
            return dict
        }
        return nil
    }
    
    func getStoriDetails(storiId:Int, and completion: @escaping RequestCompletion){
        self.storiID = storiId
        performRequest(parameter: nil, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<StoriDetailsResponse>().map(JSONObject:response)
    }
}
