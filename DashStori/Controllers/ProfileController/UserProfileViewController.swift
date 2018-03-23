//
//  UserProfileViewController.swift
//  DashStori
//
//  Created by George on 07/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var userDescription: UITextView!
    //    @IBOutlet weak var aboutUser: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var storyCount: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.showNavigationHeader(currentViewController: self)
        Utilities.createCircularImage(imageview: userImage)
        self.slideMenuController()?.addLeftGestures()
        getUserDetailsAPI()
        // Do any additional setup after loading the view.
    }
    //MARK: @IBAction
    @IBAction func editProfileAction(_ sender: Any) {
        navigateToEditProfile()
    }
    
    @IBAction func addNewStoriAction(_ sender: Any) {
        navigateToWriteStoriPage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Navigation
    func navigateToWriteStoriPage(){
        self.performSegue(withIdentifier: "ProfileToWritestori", sender: self)
    }
    
    func navigateToEditProfile(){
        self.performSegue(withIdentifier: "profileToEditProfile", sender: self)
    }
    //MARK: user details
    func getUserDetailsAPI(){
        Utilities.showActivityIndicatory()
        let manager = DashStoriManager()
        manager.getUserDetails(){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let userDetails = data as! LoginResponseModel
                if(userDetails.userDetails != nil){
                    self.setUserDetails(userDetails: userDetails.userDetails!)
                    Utilities.storeUserDetails(user: userDetails.userDetails!)
                }
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    func setUserDetails(userDetails:UserDetailsModel){
        emailAddress.text = userDetails.email
        storyCount.text = String(userDetails.totalStories)
        userName.text = userDetails.firstName + " " + userDetails.middleName + " " + userDetails.lastName
        userDescription.text = userDetails.userDescription
        let picture = userDetails.imageUrl
        if (picture != "") {
            let url = URL(string: IMAGE_URL + picture)
            userImage.kf.setImage(with: url)
        }
    }
}
