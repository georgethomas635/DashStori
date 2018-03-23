//
//  ReportAbuseRequest.swift
//  DashStori
//
//  Created by George on 19/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ReportAbuseRequest: BaseAPI {
    
    override func getMethod() -> HTTPMethod {
        return .post
    }
    override func getUrl() -> String {
        return BASE_URL + REPORT_STORI
    }
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        dict["Authorization"] = "Token " + Utilities.getUserToken()!
        return dict
    }
    func reportAbuse(storiId:Int,message:String, and completion: @escaping RequestCompletion){
        var param = [String: Any]()
        param = ["stori_id": storiId,"comment": message]
        performRequest(parameter: param, completion: completion)
    }
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<BaseResponseModel>().map(JSONObject:response)
    }
}
