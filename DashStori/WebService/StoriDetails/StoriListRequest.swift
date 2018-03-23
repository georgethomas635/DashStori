//
//  StoriListRequest.swift
//  DashStori
//
//  Created by George on 06/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class StoriListRequest: BaseAPI {

    var pageNumber = "1"
    var myStori = "0"
    override func getMethod() -> HTTPMethod {
        return .get
    }
    override func getUrl() -> String {
        return BASE_URL + LIST_OF_STORIES + pageNumber + "&mystori=" + myStori
    }
    
    override func getHeader() -> Dictionary<String, String>? {
        var dict = Dictionary<String, String>()
        let token = Utilities.getUserToken()!
        if(token != ""){
            dict["Authorization"] = "Token " + token
        }else{
            return nil
        }
        return dict
    }
    
    func listOfStories(request:ListOfStoriesRequest , and completion: @escaping RequestCompletion){
        pageNumber = String(request.page)
        myStori = String(request.myStori)
        performRequest(parameter: nil, completion: completion)
    }
    
    override func processSuccessResponse(with response: Any?) -> BaseResponseModel? {
        return Mapper<ListOfStoriesResponse>().map(JSONObject:response)
    }
}
