//
//  ForgotPasswordViewController.swift
//  DashStori
//
//  Created by George on 17/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.registerForKeyboardNotifications(scrollView: scrollView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func isMenuHeaderHidden() -> Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillDisappear(animated)
    }
    
    //MARK: IBAction
    @IBAction func submitAction(_ sender: Any) {
        if(txtemail.text == "" || !Utilities.isValidEmail(testStr: txtemail.text!)){
            showAlertMessage(errorMessage: "Please enter a valid email ID")
        }else{
            callForgotPasswordAPI()
        }
    }
    
    func setupView(){
    submitButton.layer.borderWidth = 1
    submitButton.layer.borderColor = Utilities.getColor(hex: DARK_GRAY).cgColor
    }
    //MARK: Navigation
    func navigateToHome(){
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: API Call
    func callForgotPasswordAPI(){
        Utilities.showActivityIndicatory()
        let forgotPassword = ForgotPasswordRequest()
        forgotPassword.forgotPasswordRequest(email: txtemail.text!){
            (data, error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let response = data as? BaseResponseModel
                if(response?.success)!{
                    self.showAlertMessageWithAction(message: (response?.message)!)
                }else{
                    self.showAlertMessage(errorMessage: (response?.errors)!)
                }
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    //MARK: AlertMessage
    func showAlertMessageWithAction(message:String){
        let alert = UIAlertController(title: "Password Reset", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigateToHome()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
