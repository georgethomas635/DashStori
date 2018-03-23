//
//  AuthorDetailsViewController.swift
//  DashStori
//
//  Created by George on 19/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class AuthorDetailsViewController: BaseViewController {

    @IBOutlet weak var authorPic: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var storiCount: UILabel!
    @IBOutlet weak var aboutAuthor: UITextView!
    
    var authorID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.createCircularImage(imageview: authorPic)
        callAuthorDetailsAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func storiesAction(_ sender: Any) {
        navigateToLandingPage()
    }
    //MARK: API Call
    func callAuthorDetailsAPI(){
        Utilities.showActivityIndicatory()
        let manager = DashStoriManager()
        manager.getAuthorDetails(authorID: authorID){
           (data, error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let author = data as! AuthorDetailsModel
                if(author != nil){
                    self.setDetails(author: author.authorDetails!)
                }else{
                    self.showAlertMessage(errorMessage: author.errors)
                }
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }

        }
    }
    func setDetails(author:UserDetailsModel){
        let picture = author.imageUrl
        if (picture != "") {
            let url = URL(string: IMAGE_URL + picture)
            authorPic.kf.setImage(with: url)
        }
        aboutAuthor.text = author.userDescription
        authorName.text = author.firstName +  " " + author.middleName + " " + author.lastName
        storiCount.text = String(author.totalStories)
    }
    //MARK: Navigate
    func navigateToLandingPage(){
        self.performSegue(withIdentifier: "navigateToLandingPage", sender: self)
    }
}
