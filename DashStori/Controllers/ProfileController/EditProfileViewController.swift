//
//  EditProfileViewController.swift
//  DashStori
//
//  Created by George on 10/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import YangMingShan

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var storiCount: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var encodedImage:String = ""
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications(scrollView: scrollView)
        Utilities.createCircularImage(imageview: userImage)
        self.setUserDetails()
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications(scrollView: scrollView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: @IBAction
    @IBAction func newStoriButtonClick(_ sender: Any) {
        navigateToWriteStoriPage()
    }
    @IBAction func updateProfileButtonClick(_ sender: Any) {
        var errorMessage = validateFields()
        if(errorMessage == ""){
            navigateToProfile()
        }else{
            self.showAlertMessage(errorMessage: errorMessage)
        }
    }
    
    @IBAction func updatePictureAction(_ sender: Any) {
        captureImage()
    }
    
    func navigateToWriteStoriPage(){
        self.performSegue(withIdentifier: "EditProfileToWriteStori", sender: self)
    }
    
    //MARK: API call
    func navigateToProfile(){
        Utilities.showActivityIndicatory()
        let manager = DashStoriManager()
        manager.updateProfile(firstName: firstName.text!.trimmingCharacters(in: .whitespaces), middleName: middleName.text!.trimmingCharacters(in: .whitespaces), lastName: lastName.text!.trimmingCharacters(in: .whitespaces), email: userEmail.text!, profilePicture: encodedImage, description: self.userDescription.text){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let response = data as! LoginResponseModel
                if(response.success == true){
                    Utilities.storeUserDetails(user: response.userDetails!)
                    self.performSegue(withIdentifier: "ToupdateProfile", sender: self)
                }else{
                    self.showAlertMessage(errorMessage: response.errors)
                }
                
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func setUserDetails(){
        let userDetails = Utilities.getUserDetails()
        firstName.text = userDetails.firstName
        middleName.text = userDetails.middleName
        lastName.text = userDetails.lastName
        userEmail.text = userDetails.email
        self.userDescription.text = userDetails.userDescription
        storiCount.text = String(userDetails.totalStories)
        let picture = userDetails.imageUrl
        if (picture != "") {
            let url = URL(string: IMAGE_URL + picture)
            userImage.kf.setImage(with: url)
        }
        
        lastName.autocapitalizationType = .words
        firstName.autocapitalizationType = .words
        middleName.autocapitalizationType = .words
    }
    func captureImage(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            let pickerViewController = Utilities.takePhoto(limit:1)
            self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        }
    }
    //MARK: Validation
    func validateFields() ->String {
        var errorMessage:String = ""
        if(userEmail.text?.characters.count == 0 || firstName.text?.characters.count == 0 || lastName.text?.characters.count == 0  ){
            errorMessage = "Please fill all fields"
        }else if Utilities.isValidEmail(testStr: userEmail.text!) == false{
            errorMessage = "Invalid Email ID"
        }
        return errorMessage
    }
}
//extension EditProfileViewController: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newText = (userDescription.text as NSString).replacingCharacters(in: range, with: text)
//        let numberOfChars = newText.characters.count // for Swift use count(newText)
//        return numberOfChars < 200;
//    }
//}
extension EditProfileViewController:YMSPhotoPickerViewControllerDelegate{
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated:true){
            UIGraphicsBeginImageContext(image.size)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            self.userImage.image = rotatedImage
            self.encodedImage = Utilities.encodeImageToBase64(image: Utilities.resizeImage(image: rotatedImage!, newWidth: CGFloat(RESIZE_WIDTH)))
        }
    }
}
