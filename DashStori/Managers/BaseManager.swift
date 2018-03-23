//
//  BaseManager.swift
//  DashStori
//
//  Created by QBurst on 26/09/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class BaseManager: NSObject {
    
    typealias RequestCompletion = (_ data: AnyObject?, _ error : BaseAPIError) -> Void
    
    var completion:RequestCompletion? = nil
    
    var baseCompletion:RequestCompletion { return
    {
        (data: AnyObject?, error : BaseAPIError) -> Void in
            if let handler = self.completion, let response = data as! BaseResponseModel? {
                
                if response.errors == USER_LOCKED_ERROR {
                    self.handleUserLockedState(data,error)
                }
                else {
                    if(data != nil && response.success) {
                        handler(data,error)
                    }else{
                        handler(nil,error)
                    }
                }
            }
        }
    }
    
    func handleUserLockedState (_ data: AnyObject?, _ error : BaseAPIError) -> Void {
        Utilities.hideActivityIndicatory()
        
        let topVC = UIApplication.shared.delegate?.window??.rootViewController as! SlideMenuController
        if let navigationSlideMenuVC = topVC.leftViewController as! NavigationSlideMenuController? {
            navigationSlideMenuVC.logout(data,error)
        }
    }
    
}
