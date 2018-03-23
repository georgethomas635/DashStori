//
//  AuthenticationManager.swift
//  DashStori
//
//  Created by George on 23/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class AuthenticationManager: BaseManager {

    func loginRequest(email:String, password:String, and completion: @escaping RequestCompletion){
        
        let loginModel = LoginRequestModel()
        loginModel.email = email
        loginModel.password = password
        loginModel.fromMobileFlag = true
        
        let loginRequest = LoginRequest()
        
        self.completion = completion
        loginRequest.loginRequest(request: loginModel, and: baseCompletion)
    }
    
    func signUpRequest(firstName:String,lastName:String,email:String,password:String, and completion: @escaping RequestCompletion){
        let signUpWithDetails = SignUpRequestModel()
        signUpWithDetails.email = email
        signUpWithDetails.password = password
        signUpWithDetails.firstName = firstName
        signUpWithDetails.lastName = lastName
        signUpWithDetails.fromMobileFlag = true
        
        let signUpRequest = SignUpRequest()
        
        self.completion = completion
        signUpRequest.signUp(request:signUpWithDetails, and: baseCompletion)

    }
    
    //MARK : Login with Google +
    func loginWithGooglePlusRequest(accessToken:String, method:String, and completion: @escaping RequestCompletion){
        
        let loginModel = LoginRequestModel()
        loginModel.accessToken = accessToken
        loginModel.method = method
        loginModel.fromMobileFlag = true
        
        let loginRequest = LoginRequest()
        self.completion = completion
        loginRequest.loginRequest(request: loginModel, and: baseCompletion)
    }
    
    //MARK: Logout API
    func logout(completion: @escaping RequestCompletion){
        let logoutRequest = LogoutRequest()
        self.completion = completion
        logoutRequest.logoutAPICall(completion: baseCompletion)
    }
    
    //MARK: Contact us
    func contactUs(name:String,email:String,message:String,phoneNumber:String, and completion: @escaping RequestCompletion){
        let contact = ContactUsRequestModel()
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.message = message
        contact.email = email
        
        let contactRequest = ContactUsRequest()
        
        self.completion = completion
        contactRequest.contactUs(request: contact, and: baseCompletion)
    }

}
