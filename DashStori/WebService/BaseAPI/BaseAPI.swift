//
//  BaseAPI.swift
//  DashStori
//
//  Created by QBurst on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

import Alamofire

class BaseAPI: NSObject {
    
    var SHOULD_LOG = true
    
    typealias RequestCompletion = (_ data: AnyObject?, _ error : BaseAPIError) -> Void
    
    func getUrl() -> String {
        return BASE_URL
    }
    
    func getMethod() -> HTTPMethod {
        return .post
    }
    
    func getEncording() -> ParameterEncoding{
        return JSONEncoding.default
    }
    
    func BaseUrl() -> String {
        return BASE_URL
    }
    
    func getHeader() -> Dictionary<String, String>?{
        return nil
    }
    
    func performRequest(parameter: [String: Any]?,completion: @escaping RequestCompletion) {
        
        if ReachabilityManager.isReachable(){
            print("URL : " ,getUrl())
            Alamofire.request(getUrl(), method: getMethod(), parameters: parameter,encoding: getEncording(),headers: getHeader()).responseJSON { response in
                
                switch response.result{
                case .success(let JSON):
                    if self.SHOULD_LOG {
                        Utilities.printToConsole(message:"Success with JSON: \(JSON)")
                    }
                    self.performSuccessResponseWith(JSON as AnyObject? , and: completion)
                case .failure(let error):
                    if self.SHOULD_LOG {
                        Utilities.printToConsole(message:"Request failed with error: \(error)")
                        completion(nil, BaseAPIError.initWithHttpStatusCode(500))
                    }
                    self.performFailureResponseWith(response, and: completion)
                }
                
            }
        }else{
            // MARK: Error block for No Network
            completion(nil, BaseAPIError.initWithHttpStatusCode(400))
        }
    }
    
    //MARK: Success Response Block
    func performSuccessResponseWith(_ value: AnyObject?, and completiontype: RequestCompletion) {
        
        // Create the response object
        let responseObject = self.processSuccessResponse(with: value)
        
        // Create a WebServiceError
        let error = BaseAPIError()
        error.message = responseObject?.errors
        error.type = .none
        // Send the response object and WebServiceError to the requestor
        completiontype(responseObject, error)
    }
    
    //MARK: Response processes - Override in subclass
    /**
     * Override this method to configure the process the response object.
     *
     * @return AnyObject
     */
    func processSuccessResponse(with response: Any?) -> BaseResponseModel?{
        return nil
    }
    
    
    //MARK: Failure Response Block
    
    func performFailureResponseWith(_ response: DataResponse<Any>, and completion: RequestCompletion){
        if response.response == nil{
            //MARK: Request Failure Error with no response
            //let statusCode = (response.response?.statusCode)!
            
            // Create APIError object based on http status code
//            let error : BaseAPIError  = BaseAPIError.initWithHttpStatusCode(statusCode)
//            completion(nil, error)
        } else {
            //MARK: Request Failure Error with no response
            completion(nil, BaseAPIError.initWith(response.result.error))
        }
    }
}
