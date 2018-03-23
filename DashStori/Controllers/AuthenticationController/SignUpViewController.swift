//
//  SignUpViewController.swift
//  DashStori
//
//  Created by George on 20/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ActiveLabel

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var txtConformPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var privacyLabel: ActiveLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVariables()
        clearAllfields()
        registerForKeyboardNotifications(scrollView: scrollView)
        self.setupView()
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
    @IBAction func signUpButtonClick(_ sender: Any) {
        let errorMessage = self.checkValidation()
        if(errorMessage == "")
        {
            signupAPICall()
        }else{
            self.showAlertMessage(errorMessage: errorMessage)
        }
        
    }
    @IBAction func logginButtonClick(_ sender: Any) {
        if let controller = checkIsPageExist(className: LoginPageViewController.self){
            self.navigationController?.popToViewController(controller, animated: true)
        }else{
            navigateToLogin()
        }
    }
    func navigateToLogin(){
        self.performSegue(withIdentifier: "signUpToLogin", sender: self)
    }
    func setupVariables(){
        txtFirstName.autocapitalizationType = .words
        txtLastName.autocapitalizationType = .words
    }
    
    //MARK: Validation
    func checkValidation() -> String{
        var errorMessage:String = ""
        if(txtEmail.text?.characters.count == 0 || txtFirstName.text?.characters.count == 0 || txtLastName.text?.characters.count == 0 || txtPassword.text?.characters.count == 0 ){
            errorMessage = "Please fill all fields"
        }else if( (txtPassword.text?.characters.count)! < 6){
            errorMessage = "Enter a password with minimum 6 characters"
        }else if(txtPassword.text != txtConformPassword.text){
            errorMessage = "Password does not match Confirm password    "
        }else if Utilities.isValidEmail(testStr: txtEmail.text!) == false{
            errorMessage = "Invalid Email ID"
        }
        return errorMessage
    }
    
    override func isMenuHeaderHidden() -> Bool {
        return true
    }
    
    //MARK: Design View
    func setupView(){
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = Utilities.getColor(hex: DARK_GRAY).cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        
        privacyLabel.customize { (label) in
            
            //Regex that looks for "Terms of Service" or "Privacy Policy"
            let customType = ActiveType.custom(pattern: "\\s(Terms of Service)|(Privacy Policy)\\b")
            label.enabledTypes = [customType]
            label.customColor[customType] = UIColor.blue
            label.customSelectedColor[customType] = UIColor.lightGray
            
            label.handleCustomTap(for: customType) { element in
                self.handleTermsAndPrivacy(element)
            }
        }
    }
    
    //MARK: Terms and Privacy
    func handleTermsAndPrivacy(_ element: String) -> Void {
        var url = ""
        if element ==  "Terms of Service"{
            url = BASE + "tos/mobile" //"https://github.com/optonaut/ActiveLabel.swift"
        }
        else {
            url = BASE + "privacy-policy/mobile" //"https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial"
        }
        
        if url != "" {
            self.performSegue(withIdentifier: "signUpToWebView", sender: url)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToWebView" {
            let destination = segue.destination as! WebViewController
            let urlString = sender as! String
            destination.urlString = urlString
        }
    }
    
    //MARK: SignUp API
    func signupAPICall(){
        Utilities.showActivityIndicatory()
        let authManager = AuthenticationManager()
        authManager.signUpRequest(firstName: txtFirstName.text!, lastName: txtLastName.text!, email: txtEmail.text!, password: txtPassword.text!){
            (data,error) in
            var message = ""
            if(data != nil) {
                let signUpResponse = data as! SignUpResponseModel
                message = signUpResponse.verificationMessage
            }
            else {
                message = "User with this email exist"
            }
            Utilities.hideActivityIndicatory()
            self.showAlertMessageWithAction(message: message)
        }
    }
    func clearAllfields(){
        txtFirstName.text = ""
        txtLastName.text = ""
        txtPassword.text = ""
        txtConformPassword.text = ""
        txtEmail.text = ""
    }
    
    //MARK: AlertMessage
    func showAlertMessageWithAction(message:String){
        let alert = UIAlertController(title: "Signup", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.clearAllfields()
            self.navigateToLogin()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
