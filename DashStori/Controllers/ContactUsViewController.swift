//
//  ContactUsViewController.swift
//  DashStori
//
//  Created by George on 15/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
 
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications(scrollView: scrollView)
        txtPhoneNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillDisappear(animated)
    }
    //MARK: IBAction
    @IBAction func sendMessageAction(_ sender: Any) {
        let errorMessage = checkValication()
        if(errorMessage == ""){
            contactUsAPI()
        }else{
            showAlertMessage(errorMessage: errorMessage)
        }
    }
    
    func checkValication() ->String{
        var errorMessage:String = ""
        if(txtName.text == ""){
            errorMessage = "Name can't be blank"
        }else if(txtEmail.text == ""){
            errorMessage = "Enter an email"
        }else if Utilities.isValidEmail(testStr: txtEmail.text!) == false{
            errorMessage = "Invalid Email ID"
        }else if(txtPhoneNumber.text?.characters.count == 0){
            errorMessage = "Enter a phone number"
        }else if(txtMessage.text == ""){
            errorMessage = "Message field should not be blank!"
        }
        return errorMessage
    }
    //MARK: API Call
    func contactUsAPI(){
        Utilities.showActivityIndicatory()
        let manager = AuthenticationManager()
        manager.contactUs(name: txtName.text!, email: txtEmail.text!, message: txtMessage.text!, phoneNumber:txtPhoneNumber.text! ){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                self.navigateToHome()
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    //MARK: Navigate
    func navigateToHome(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789 +-").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
