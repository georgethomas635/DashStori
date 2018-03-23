//
//  ViewController.swift
//  DashStori
//
//  Created by George on 01/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import FacebookCore
import FacebookLogin

class LoginPageViewController: BaseViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications(scrollView: scrollView)
        setupView()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = CLIENTID
        password.delegate = self
    }
    
    override func isMenuHeaderHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillDisappear(animated)
    }
    
    //MARK: @IBAction
    @IBAction func googleSignUpButtonClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
   
    @IBAction func forgotPasswordAction(_ sender: Any) {
        navigateTOForgotPasswordScreen()
    }
    @IBAction func loginButtonClick(_ sender: Any) {
        let validationMessage = checkValidation()
        if(validationMessage == ""){
            Utilities.showActivityIndicatory()
            
            let authManager = AuthenticationManager()
            authManager.loginRequest(email: userName.text!, password: password.text!){
                (data,error) in
                if(data != nil){
                    Utilities.hideActivityIndicatory()
                    let loginResponse = data as! LoginResponseModel
                    if(loginResponse.success == true){
                        Utilities.storeToken(token: loginResponse.token)
                        Utilities.storeUserDetails(user: loginResponse.userDetails!)
                        self.navigateToHome()
                    }else{
                        self.showAlertMessage(errorMessage: loginResponse.errors)
                    }
                    
                }else{
                    Utilities.hideActivityIndicatory()
                    self.showAlertMessage(errorMessage: error.message!)
                }
            }
        }else{
            self.showAlertMessage(errorMessage: validationMessage)
        }
    }
    
    @IBAction func signUpButtonClick(_ sender: Any) {
        if let controller = checkIsPageExist(className: SignUpViewController.self){
            self.navigationController?.popToViewController(controller, animated: true)
        }else{
            clearFields()
            navigateToSignup()
        }
    }
    
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK : Facebook Login
    
    @IBAction func facebookSignUpButtonClick(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn([ .publicProfile,.email ], viewController: self) {
            loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.saveLoginDetaisToServer(accessToken:accessToken.authenticationToken,method: FACEBOOK)
            }
        }
    }
    func clearFields(){
        userName.text = ""
        password.text = ""
    }
    
    //MARK: Navigate
    func navigateToHome(){
        self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    func navigateToSignup(){
        self.performSegue(withIdentifier: "loginToSignUp", sender: self)
    }
    func navigateTOForgotPasswordScreen(){
        self.performSegue(withIdentifier: "navigateToForgotPasswordPage", sender: self)
    }
    //MARK: Validation
    func checkValidation() -> String{
        var errorMessage:String = ""
        if(userName.text?.characters.count == 0){
            errorMessage = "Enter an email"
        }else if(password.text?.characters.count == 0){
            errorMessage = "Please enter your password."
        }else if Utilities.isValidEmail(testStr: userName.text!) == false{
            errorMessage = "Invalid Email ID"
        }
        return errorMessage
    }
    
    //MARK:Design View
    func setupView(){
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = Utilities.getColor(hex: DARK_GRAY).cgColor
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    //MARK:Google SignIn Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            saveLoginDetaisToServer(accessToken: user.authentication.accessToken,method: GOOGLE)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func saveLoginDetaisToServer(accessToken:String,method:String){
        Utilities.showActivityIndicatory()
        let authManager = AuthenticationManager()
        authManager.loginWithGooglePlusRequest(accessToken: accessToken, method: method){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let loginResponse = data as! LoginResponseModel
                if(loginResponse.success == true){
                    Utilities.storeToken(token: loginResponse.token)
                    Utilities.storeUserDetails(user: loginResponse.userDetails!)
                    self.navigateToHome()
                }else{
                    self.showAlertMessage(errorMessage: loginResponse.errors)
                }
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
}
extension LoginPageViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        return true;
    }
}

