//
//  BaseViewController.swift
//  DashStori
//
//  Created by George on 20/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var keyboardScrollVew : UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slideMenuController()?.addLeftGestures()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        if let vc = self.navigationController?.topViewController as? BaseViewController {
            vc.view.endEditing(true)
        }else{
            self.view.endEditing(true)
        }
    }
    
    func registerForKeyboardNotifications(scrollView: UIScrollView)  {
        keyboardScrollVew = scrollView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        addTabGesture()
    }
    
    func addTabGesture(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)
    }
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = keyboardScrollVew!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        keyboardScrollVew?.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        keyboardScrollVew?.contentInset = contentInset
    }
    
    func deregisterForKeyboardNotifications(scrollView:UIScrollView) {
        
        let centre = NotificationCenter.default
        centre.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        centre.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:Alert Message
    func showAlertMessage(errorMessage:String){
        let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIsPageExist(className: BaseViewController.Type) -> BaseViewController?{
        let controllers = self.navigationController?.viewControllers as? [BaseViewController]
        var result:BaseViewController? = nil
        for controller in controllers!{
            let dataType = type(of: controller)
            if dataType == className {
                result = controller
            }
        }
        return result
    }
    
    func isMenuHeaderHidden() -> Bool {
        return false;
    }
}
