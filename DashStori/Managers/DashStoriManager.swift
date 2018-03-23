//
//  DashStoriManager.swift
//  DashStori
//
//  Created by George on 31/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import GooglePlaces

class DashStoriManager: BaseManager {
    
    func publishStori(firstName:String,middleName:String,lastName:String,dateOfBirth:String,dateOfDeath:String, description:String, linkUrl:[UrlDetails],videoUrl:[UrlDetails],coverPic:UrlDetails,galleryImages:[UrlDetails],location: CLLocationCoordinate2D,saveAsDraft:Bool , and completion: @escaping RequestCompletion){
        
        let storiDetails = PublishStoriRequestModel()
        storiDetails.firstName = firstName
        storiDetails.middleName = middleName
        storiDetails.lastName = lastName
        if(dateOfDeath != ""){
            storiDetails.dateOfDeath = dateOfDeath
        }
        if(dateOfBirth != ""){
            storiDetails.dateOfBirth = dateOfBirth
        }
        storiDetails.linkUrl = linkUrl
        storiDetails.videoUrl = videoUrl
        if(description != START_STORI){
            storiDetails.storyDetails = description
        }
        storiDetails.coverPic = coverPic
        storiDetails.images = galleryImages
        storiDetails.saveAsDraft = saveAsDraft
        
        let address = Location()
        if(location.latitude != 0.0){
            address.latitude = location.latitude
            address.longitude = location.longitude
            storiDetails.location.append(address)
        }
        
        
        let publishStory = PublishStoriRequest()
        
        self.completion = completion
        publishStory.publishStori(request: storiDetails, and: baseCompletion)
        
    }
    
    //MARK: story details in edit mode
    func getEditStoriDetails(storiID:Int, and completion: @escaping RequestCompletion){
        let editStoriRequest = EditStoriRequest()
        
        self.completion = completion
        editStoriRequest.getStoriDetails(storiId: storiID, and: baseCompletion)
    }
    
    //MARK: story details in edit mode
    func deleteStori(storiID:Int, and completion: @escaping RequestCompletion){
        let deleteStoriRequest = DeleteStoriRequest()
        
        self.completion = completion
        deleteStoriRequest.deleteStori(storiId: storiID, and: baseCompletion)
    }
    
    //MARK: List of stories
    func getListOfStories(myStori:Int,page:Int,and completion: @escaping RequestCompletion){
        let requestDetails = ListOfStoriesRequest()
        requestDetails.page = page
        requestDetails.myStori = myStori
        
        let listOfStori = StoriListRequest()
        
        
        self.completion = completion
        listOfStori.listOfStories(request:requestDetails, and: baseCompletion)
    }
    
    //MARK: List of locations of stories
    func getListOfWorldStories(completion: @escaping RequestCompletion){
        let worldStoriRequest = WorldStoriListRequest()
        self.completion = completion
        worldStoriRequest.worldStories(request: worldStoriRequest, and: baseCompletion)
    }
    
    //MARK: Update Profile
    func updateProfile(firstName:String,middleName:String,lastName:String,email:String,profilePicture:String,description:String,and completion: @escaping RequestCompletion){
        let userDetails = UpdateProfileRequestModel()
        userDetails.firstName = firstName
        userDetails.lastName = lastName
        userDetails.middleName = middleName
        userDetails.email = email
        userDetails.aboutUser = description
        userDetails.profilePic = profilePicture
        
        let updateProfile = UpdateProfileRequest()
        
        self.completion = completion
        updateProfile.updateUserDetails(request: userDetails, and: baseCompletion)
    }
    
    //MARK User Details
    func getUserDetails(completion: @escaping RequestCompletion){
        let userDetails = ProfileDetailsRequest()
        
        self.completion = completion
        userDetails.getUserDetails(completion: baseCompletion)
    }
    
    //MARK: Stori Details
    func getStoriDetails(storiID:Int, and completion: @escaping RequestCompletion){
        let stori = StoriDetailsRequest()
        
        self.completion = completion
        stori.getStoriDetails(storiId: storiID, and: baseCompletion)

    }
    
    //MARK: Author Details
    func getAuthorDetails(authorID:Int, and completion: @escaping RequestCompletion){
        let authorDetails = AuthorDetailsRequest()
        
        self.completion = completion
        authorDetails.getAuthorDetails(authorId: authorID, and:  baseCompletion)
    }
    
    //MARK: Update Stori
    func updateStori(storiID:Int,storiDetails:EditStoriDetails, and completion: @escaping RequestCompletion){
        let storiUpdate = UpdateStoriRequest()
        
        self.completion = completion
        storiUpdate.updateStori(storiId: storiID,details:storiDetails, and: baseCompletion)
    }
}
