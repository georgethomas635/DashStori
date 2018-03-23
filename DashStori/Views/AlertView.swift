//
//  AlertView.swift
//  DashStori
//
//  Created by George on 22/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

enum AlertType {
    case video
    case link
}

protocol AlertViewDelegate {
    func alertDialoge(_ alertView:AlertView,listOfUrl:[UrlDetails], alertTitle text:String)
}
class AlertView: UIView, AlertInputDelegate {
    
    var alertType: AlertType = .video
    var maxInputCount = 5
    var textviewPlaceholderText:String!
    var alertInputView:AlertInput?
    var delegate:AlertViewDelegate! = nil
    
    @IBOutlet weak var dialogeBoxTitle: UILabel!
    @IBOutlet weak var inputStack: UIStackView!
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        var listOflinks :[UrlDetails] = []
        var index = 0
        let stackElements = inputStack.subviews
        for stackItem in stackElements {
            index = index+1
            let details = self.alertType == .video ? VideoUrlDetails() : LinkUrlDetails()
            details.newURL = (stackItem.viewWithTag(100) as! UITextField).text!
            listOflinks.append(details)
        }
        delegate.alertDialoge(self, listOfUrl: listOflinks, alertTitle: dialogeBoxTitle.text!)
        self.removeFromSuperview()
    }
    
    func addNewInput(textviewPlaceholder: String,listOfUrl: [UrlDetails],viewtext:String) {
        alertInputView = Bundle.main.loadNibNamed("AlertInput", owner: self, options: nil)?[0] as? AlertInput
        if(listOfUrl.count > 0){
            for link in listOfUrl {
                addNewInput(textviewPlaceholder: "",listOfUrl: [],viewtext: link.URL)
            }
            if inputStack.arrangedSubviews.count < maxInputCount {
                addNewInput(textviewPlaceholder: textviewPlaceholder,listOfUrl: [],viewtext: "")
            }            
        }
        if(viewtext != "" ){
            alertInputView?.actionButton.setBackgroundImage(#imageLiteral(resourceName: "remove"), for: .normal)
            alertInputView?.actionButtonFlag = false
            alertInputView?.inputText.text = viewtext
        }else{
            alertInputView?.inputText.placeholder = textviewPlaceholder
        }
        alertInputView?.inputText.tag = 100
        textviewPlaceholderText = textviewPlaceholder
        if inputStack.arrangedSubviews.count == maxInputCount-1 {
            alertInputView?.actionButton.isHidden = true
        }
        alertInputView?.delegate = self
        inputStack.addArrangedSubview(alertInputView!)
    }
    
    func showAlert(title:String) {
        dialogeBoxTitle.text = title
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(self)
        }
        
        
    }
    //MARK: AlertInput ButtonClick
    func alertInput(_ alertInput: AlertInput, addButtonClick button: UIButton) {
        if inputStack.arrangedSubviews.count < maxInputCount {
            addNewInput(textviewPlaceholder: textviewPlaceholderText,listOfUrl: [],viewtext: "")
        }
        
    }
    
    func alertInput(_ alertInput: AlertInput, closeButtonClick button: UIButton) {
        alertInput.removeFromSuperview()
        if inputStack.arrangedSubviews.count < maxInputCount {
            let view = inputStack.arrangedSubviews.last as! AlertInput
            view.actionButton.isHidden = false
            view.actionButton.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
        }
    }
    
}
