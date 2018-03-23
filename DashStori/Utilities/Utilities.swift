//
//  Utilities.swift
//  DashStori
//
//  Created by George on 20/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import ObjectMapper
import YangMingShan

class Utilities: NSObject {
    
    
    static func getColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func printToConsole(message:String) {
        print(message)
    }
    
    // MARK: Email Validation
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    static func showNavigationHeader(currentViewController: UIViewController){
        currentViewController.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    //MARK: Store UserDefaults
    static func storeToken(token:String){
        UserDefaults.standard.setValue(token, forKey: "user_auth_token")
        print("\(UserDefaults.standard.value(forKey: "user_auth_token")!)")
    }
    
    static func getUserToken() -> String!{
        let token:String = UserDefaults.standard.value(forKey: "user_auth_token") as! String? ?? ""
        return token
    }
    
    static func storeUserDetails(user:UserDetailsModel){
        UserDefaults.standard.setValue(user.toJSONString(), forKey: "user_details")
    }
    
    
    static func getUserDetails() -> UserDetailsModel{
        let jsonUserDetails = UserDefaults.standard.value(forKey: "user_details")! as! String
        let user = Mapper<UserDetailsModel>().map(JSONString: jsonUserDetails)
        return user!
    }
    
    //MARK: Encode Image
    static func encodeImageToBase64(image : UIImage) -> String{
        
        let imageData : Data = UIImagePNGRepresentation(image)! as Data
        let strBase64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return strBase64
    }
    //MARK: Decode Image
    func decodeBase64ToImage(base64 : String) -> UIImage{
        
        let dataDecoded : NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage : UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    //MARK: Circular Image
    static func createCircularImage(imageview:UIImageView){
        imageview.layer.borderWidth = 0.5
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.black.cgColor
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.clipsToBounds = true
    }
    
    //MARK: #imageLiteral(resourceName: "YMSIconCamera")
    static func takePhoto(limit:Int) -> YMSPhotoPickerViewController{
        let pickerViewController = YMSPhotoPickerViewController.init()
        pickerViewController.numberOfPhotoToSelect = UInt(limit)
        let customColor = UIColor.black
        pickerViewController.theme.navigationBarBackgroundColor = customColor
        pickerViewController.theme.tintColor = UIColor.init(red: 211.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        pickerViewController.theme.cameraIconColor = UIColor.init(red: 211.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        pickerViewController.theme.titleLabelTextColor = UIColor.white
        return pickerViewController
    }
    
    //MARK: Activity Indicator
    static let container: UIView = UIView()
    static func showActivityIndicatory() {
        
        if let app = UIApplication.shared.delegate as? AppDelegate , let window = app.window {
            
            
            container.frame = window.bounds
            container.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
            
            let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            actInd.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            actInd.center = container.center
            actInd.activityIndicatorViewStyle =
                UIActivityIndicatorViewStyle.whiteLarge
            container.addSubview(actInd)
            window.addSubview(container)
            actInd.startAnimating()
        }
    }
    
    static func hideActivityIndicatory() {
        container.removeFromSuperview()
    }
    static func setShadow(forView:UIView){
        forView.layer.shadowColor = UIColor.black.cgColor
        forView.layer.shadowOpacity = 0.4
        forView.layer.shadowOffset = CGSize(width: 0.8, height: 1)
        forView.layer.shadowRadius = 1
    }
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
