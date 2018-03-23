//
//  NavigationSlideMenuController.swift
//  DashStori
//
//  Created by George on 29/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import GoogleSignIn
import FacebookLogin
class NavigationSlideMenuController: BaseViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var profileView: UIView!
    var profileViewController: UserProfileViewController!
    
    var token:String = ""
    private var _buttonActionPending: Bool  = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideMenuItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let landingPage = segue.destination as! HomePageViewController
        landingPage.profileView = profileView
        landingPage.logoutView = logoutView
    }
    //MARK: Pop to rootview
    
    func popViewController(navigationController: UINavigationController,animated: Bool, completion: @escaping () -> ()) {
        navigationController.popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
    
    //MARK: Navigation
    func navigateToProfile(){
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: { 
                nav.pushViewController(profileViewController, animated: true)

            })
        }
        self.slideMenuController()?.closeLeft()
    }
    
    func navigateToHomePage(){
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            nav.popToRootViewController(animated: true)
        }
        self.slideMenuController()?.closeLeft()
    }
    
    func navigateToHomeWithoutLogin(){
        let homePageViewController = storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            nav.setViewControllers([homePageViewController], animated: true)
        }
        self.slideMenuController()?.closeLeft()
        
    }
    
    func navigateToPublishStoriPage(){
        let homePageViewController = storyboard?.instantiateViewController(withIdentifier: "WriteStoriViewController") as! WriteStoriViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: {
                nav.pushViewController(homePageViewController, animated: true)
                
            })
        }
        self.slideMenuController()?.closeLeft()
    }
    
    func navigateToLogin(){
        let loginPageViewController = storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: {
                nav.pushViewController(loginPageViewController, animated: true)
                
            })
        }
        self.slideMenuController()?.closeLeft()
    }
    func navigateToContactUsPage(){
        let homePageViewController = storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: {
                nav.pushViewController(homePageViewController, animated: true)
                
            })
        }
        self.slideMenuController()?.closeLeft()
    }
    
    func navigateToWorldStories() {
        let worldStoriesViewController = storyboard?.instantiateViewController(withIdentifier: "WorldStoriesViewController") as! WorldStoriesViewController
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: {
                nav.pushViewController(worldStoriesViewController, animated: true)
                
            })
        }
        self.slideMenuController()?.closeLeft()
    }
    
    func navigateToWebView(url: String) {
        let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webViewController.urlString = url
        if let nav = self.slideMenuController()?.mainViewController as? UINavigationController{
            popViewController(navigationController: nav, animated: false, completion: {
                nav.pushViewController(webViewController, animated: true)
            })
        }
        self.slideMenuController()?.closeLeft()
    }
    
    
    //MARK: @IBAction
    @IBAction func newStoriButtonAction(_ sender: Any) {
        token = Utilities.getUserToken()
        if(token != ""){
            let currentViewController = self.slideMenuController()?.mainViewController?.childViewControllers
            if (currentViewController?[(currentViewController?.count)!-1] is WriteStoriViewController) {
                let home = currentViewController?[0] as! HomePageViewController
                home.navigationMode = true
                let pageHeading = (currentViewController?[(currentViewController?.count)!-1] as! WriteStoriViewController).pageHeading.text
                if(pageHeading == EDIT_PAGE_HEADING){
                    navigateToPublishStoriPage()
                }else{
                    self.slideMenuController()?.closeLeft()
                }
            }
            else if !(currentViewController?[(currentViewController?.count)!-1] is WriteStoriViewController) {
                navigateToPublishStoriPage()
            }else{
                self.slideMenuController()?.closeLeft()
            }
        }else{
            navigateToLogin()
        }
    }
    @IBAction func contactUsAction(_ sender: Any) {
        let currentViewController = self.slideMenuController()?.mainViewController?.childViewControllers
        if !(currentViewController?[(currentViewController?.count)!-1] is ContactUsViewController) {
//            let home = currentViewController?[0] as! HomePageViewController
//            home.navigationMode = true
            navigateToContactUsPage()
        }else{
            self.slideMenuController()?.closeLeft()
        }
    }
    
    @IBAction func termsOfServiceAction(_ sender: Any) {
        let url =  BASE + "tos/mobile"
        navigateToWebView(url: url)
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        let url = BASE + "privacy-policy/mobile"
        navigateToWebView(url: url)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigateToLogin()
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
        if(_buttonActionPending) {return;}
        
        _buttonActionPending = true;
        let manager = AuthenticationManager()
        manager.logout { (data, error) in
            self.logout(data, error);
            self._buttonActionPending = false;
        }
    }
    
    func logout(_ data: AnyObject?, _ error : BaseAPIError) -> Void {
        if(data != nil){
            let logoutResponse = data as! BaseResponseModel
            
            GIDSignIn.sharedInstance().signOut() //Google logout
            
            Utilities.storeToken(token: "")
            self.slideMenuController()?.removeLeftGestures()
            self.setSlideMenuItems()
            
            if(logoutResponse.success == true){
                self.navigateToHomeWithoutLogin()
            }
            else {
                self.navigateToHomeIfNeeded()
                self.showAlertMessage(errorMessage: USER_LOCKED_ERROR)
            }
        }else{
            self.showAlertMessage(errorMessage: error.message!)
        }
    }
    
    func navigateToHomeIfNeeded() {
        
        let homePageViewController = storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        if  let nav = self.slideMenuController()?.mainViewController as? UINavigationController {
            if (nav.topViewController as? BaseViewController) != nil {
                let when = DispatchTime.now() + 0.99 // in sesonds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    DispatchQueue.main.async(execute: {() -> Void in
                        nav.setViewControllers([homePageViewController], animated: true)
                    })
                }
            }
        }
        self.slideMenuController()?.closeLeft()
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        let currentViewController = self.slideMenuController()?.mainViewController?.childViewControllers
        if !(currentViewController?[(currentViewController?.count)!-1] is HomePageViewController) {
            let home = currentViewController?[0] as! HomePageViewController
            home.navigationMode = false
            navigateToHomePage()
        }else{
            self.slideMenuController()?.closeLeft()
        }
        
    }
    
    @IBAction func ProfileButtonClick(_ sender: Any) {
        let currentViewController = self.slideMenuController()?.mainViewController?.childViewControllers
        if !(currentViewController?[(currentViewController?.count)!-1] is UserProfileViewController) {
//            let home = currentViewController?[0] as! HomePageViewController
//            home.navigationMode = true
            navigateToProfile()
        }else{
            self.slideMenuController()?.closeLeft()
        }
    }
    
    @IBAction func worldMapButtonTap(_ sender: Any) {
        let currentViewController = self.slideMenuController()?.mainViewController?.childViewControllers
        if !(currentViewController?[(currentViewController?.count)!-1] is WorldStoriesViewController) {
            navigateToWorldStories()
        }else{
            self.slideMenuController()?.closeLeft()
        }
    }
    
    
    func setSlideMenuItems(){
        token = Utilities.getUserToken()
        if (token != ""){
            logoutView.isHidden = false
            profileView.isHidden = false
            loginView.isHidden = true
        }else{
            logoutView.isHidden = true
            profileView.isHidden = true
            loginView.isHidden = false
        }
    }
}
