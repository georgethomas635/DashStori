//
//  WriteStoriViewController.swift
//  DashStori
//
//  Created by George on 21/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import YangMingShan

class WriteStoriViewController: BaseViewController,UITextFieldDelegate, TextToolBarDelegate {
    
    @IBOutlet weak var pageHeading: UILabel!
    @IBOutlet weak var storiButtonsBackgroundView: UIView!
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var publishStoriButton: UIButton!
    @IBOutlet weak var saveDraftView: UIView!
    @IBOutlet weak var editStoriCancelButton: UIButton!
    @IBOutlet weak var txtDateofDeath: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtfirstName: UITextField!
    @IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtStory: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var toolBar: TextToolBar?
    var listOfLinkUrl : [LinkUrlDetails] = []
    var listOfVideoUrl : [VideoUrlDetails] = []
    let datePickerView = UIDatePicker()
    var imageDialoge:AddImageDialoge! = nil
    var coverPicture = UrlDetails()
    var storiImages: [UrlDetails] = []
    var linkAlertView:AlertView? = nil
    var videoAlertView:AlertView? = nil
    var storiLocation = CLLocationCoordinate2D()
    var editMode:Bool = false
    var saveAsDraftFlag:Bool = false
    var storiId:Int = 0
    var storiDetails = PublishStoriRequestModel()
    var galleryController: EditGalleryImagesViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications(scrollView: scrollView)
        setPlaceholder()
        setupVariable()
        setShadow()
        txtDateofDeath.delegate = self
        txtDateOfBirth.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillDisappear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "navigateToMapView"){
            let locationCoordinates = segue.destination as! StoriLocationViewController
            locationCoordinates.storiLocation = storiLocation
        }
    }
    
    //MARK: IBAction
    @IBAction func linkButtonClick(_ sender: Any) {
        dismissKeyboard()
        showAlertDialoge(title:LINK, inputTextPlaceHolder:ADD_URL)
    }
    @IBAction func photoButtonClick(_ sender: Any) {
        dismissKeyboard()
        if(editMode){
            popupEditGallery()
        }else{
            showAlertAddPicture()
        }
    }
    @IBAction func saveDraftAction(_ sender: Any) {
        if(txtfirstName.text != ""){
            if(txtLastName.text != ""){
                if(!saveAsDraftFlag){
                    publishStoriAPICall(draftFlag: true)
                }else{
                    updateStoriAPICall(forPublishing: false)
                }
            }else{
                self.showAlertMessage(errorMessage: "Last name can't be blank")
            }
        }else{
            self.showAlertMessage(errorMessage: "First name can't be blank")
        }
    }
    
    @IBAction func editModeCancelAction(_ sender: Any) {
        cancelToStoriDetails()
    }
    @IBAction func videoButtonClick(_ sender: Any) {
        dismissKeyboard()
        showVideoAlertDialoge(title:VIDEO, inputTextPlaceHolder:ADD_VIDEO_URL)
    }
    @IBAction func documentButtonClick(_ sender: Any) {
        dismissKeyboard()
        showAlertDialoge(title:RELATED_DOCUMENTS, inputTextPlaceHolder:UPLOAD_FILES)
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
        navigateToHome()
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        getMapView()
    }
    
    @IBAction func publishStoriAction(_ sender: Any) {
        if(editMode){
            let errorMessage = validateAllFields()
            if(errorMessage == ""){
                updateStoriAPICall(forPublishing: true)
            }else{
                self.showAlertMessage(errorMessage: errorMessage)
            }
        }else{
            let errorMessage = validateAllFields()
            if(errorMessage == ""){
                publishStoriAPICall(draftFlag: false)
            }else{
                self.showAlertMessage(errorMessage: errorMessage)
            }
        }
    }
    
    func setPlaceholder(){
        txtStory.text = START_STORI
        txtStory.textColor = UIColor.lightGray
    }
    
    func setupVariable(){
        txtfirstName.autocapitalizationType = .words
        txtLastName.autocapitalizationType = .words
        txtMiddleName.autocapitalizationType = .words
        if(editMode){
            getStoriDetails()
            pageHeading.text = EDIT_PAGE_HEADING
            editStoriCancelButton.isHidden = false
            if(!saveAsDraftFlag){
                saveDraftView.isHidden = true
                publishStoriButton.setTitle(UPDATE_STORI, for: .normal)
            }else{
                editStoriCancelButton.isHidden = true
                saveDraftView.isHidden = false
                publishStoriButton.setTitle(PUBLISH, for: .normal)
            }
        }else{
            pageHeading.text = WRITE_PAGE_HEADING
            editStoriCancelButton.isHidden = true
            saveDraftView.isHidden = false
            publishStoriButton.setTitle(PUBLISH, for: .normal)
        }
    }
    func setShadow(){
        Utilities.setShadow(forView: storiButtonsBackgroundView)
        Utilities.setShadow(forView: contentBackgroundView)
        
    }
    //MARK: PublishStori API
    func publishStoriAPICall(draftFlag:Bool){
        Utilities.showActivityIndicatory()
        let storiManager = DashStoriManager()
        storiManager.publishStori(firstName: txtfirstName.text!, middleName: txtMiddleName.text!, lastName: txtLastName.text!, dateOfBirth: txtDateOfBirth.text!, dateOfDeath: txtDateofDeath.text!,description:txtStory.text!,linkUrl: listOfLinkUrl,videoUrl: listOfVideoUrl,coverPic:coverPicture,galleryImages: storiImages,location: storiLocation,saveAsDraft: draftFlag){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let storiPublishResponse = data as! BaseResponseModel
                if(storiPublishResponse.success == true){
                    self.navigateToHome()
                }else{
                    self.showAlertMessage(errorMessage: storiPublishResponse.errors)
                }
                
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    //MARK: EditMode API
    func getStoriDetails(){
        Utilities.showActivityIndicatory()
        let storiManager = DashStoriManager()
        
        storiManager.getEditStoriDetails(storiID: storiId) {
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let editStoriDetails = data as! EditStoriResponse
                self.editModeSetupVariable(details:editStoriDetails.storiData!)
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func updateStoriAPICall(forPublishing:Bool){
        let manager = DashStoriManager()
        Utilities.showActivityIndicatory()
        let editStoriDetails = EditStoriDetails()
        editStoriDetails.firstName = txtfirstName.text!
        editStoriDetails.lastName = txtLastName.text!
        editStoriDetails.middleName = txtMiddleName.text!
        editStoriDetails.dateOfBirth = txtDateOfBirth.text!
        editStoriDetails.dateOfDeath = txtDateofDeath.text
        if(txtStory.text != START_STORI){
            editStoriDetails.storyDetails = txtStory.text
        }
        if(storiLocation.latitude != 0.0){
            let address = Location()
            address.latitude = storiLocation.latitude
            address.longitude = storiLocation.longitude
            editStoriDetails.location.append(address)
        }
        editStoriDetails.linkList = listOfLinkUrl
        editStoriDetails.videoList = listOfVideoUrl
        editStoriDetails.imageList = storiImages
        editStoriDetails.coverPic = [coverPicture]
        if(saveAsDraftFlag && !forPublishing){
            editStoriDetails.saveAsDraft = true
        }
        manager.updateStori(storiID: storiId, storiDetails: editStoriDetails){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let storiUpdateResponse = data as! BaseResponseModel
                if(storiUpdateResponse.success == true){
                    self.navigateToHome()
                }else{
                    self.showAlertMessage(errorMessage: storiUpdateResponse.errors)
                }
                
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func editModeSetupVariable(details:EditStoriDetails){
        txtfirstName.text = details.firstName
        txtMiddleName.text = details.middleName
        txtLastName.text = details.lastName
        txtDateOfBirth.text = details.dateOfBirth
        txtDateofDeath.text = details.dateOfDeath
        txtStory.text = details.storyDetails
        txtStory.textColor = UIColor.black
        if(details.coverPic.count != 0){
            self.coverPicture = details.coverPic[0]
        }
        if(details.location.count > 0 && details.location[0].latitude != 0){
            storiLocation.latitude = details.location[0].latitude
            storiLocation.longitude = details.location[0].longitude
        }
        self.listOfLinkUrl = details.linkList
        self.listOfVideoUrl = details.videoList
        self.storiImages = details.imageList
    }
    //MARK: Add Pictures
    func showAlertAddPicture(){
        imageDialoge = Bundle.main.loadNibNamed("AddImageDialoge", owner: self, options: nil)?[0] as! AddImageDialoge
        imageDialoge.frame = self.view.bounds
        imageDialoge.showAlert()
        imageDialoge.delegate = self
    }
    
    //MARK: Link & Video
    func showAlertDialoge(title:String, inputTextPlaceHolder:String){
        if(linkAlertView == nil){
            linkAlertView = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?[0] as? AlertView
            linkAlertView?.frame = self.view.bounds
            linkAlertView?.addNewInput(textviewPlaceholder: inputTextPlaceHolder,listOfUrl: listOfLinkUrl,viewtext: "")
            linkAlertView?.showAlert(title: title)
            linkAlertView?.delegate = self
            linkAlertView?.alertType = .link
        }else{
            
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.addSubview(linkAlertView!)
            }
        }
    }
    func showVideoAlertDialoge(title:String, inputTextPlaceHolder:String){
        if(videoAlertView == nil){
            videoAlertView = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?[0] as? AlertView
            videoAlertView?.frame = self.view.bounds
            videoAlertView?.addNewInput(textviewPlaceholder: inputTextPlaceHolder,listOfUrl: listOfVideoUrl,viewtext: "")
            videoAlertView?.showAlert(title: title)
            videoAlertView?.delegate = self
            videoAlertView?.alertType = .video
        }else{
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.addSubview(videoAlertView!)
            }
            
        }
    }
    
    //MARK: Validation
    func validateAllFields() ->String {
        var message:String = ""
        let storiCountInWords = txtStory.text.components(separatedBy: "\n").count + txtStory.text.components(separatedBy: " ").count
        if(txtfirstName.text == ""){
            message = "First name can't be blank"
        }else if(txtLastName.text == ""){
            message = "Last name can't be blank"
        }else if(txtDateOfBirth.text == ""){
            message = "Date of birth is required"
        }else if(storiCountInWords == 0){
            message = "Please add short stori"
        }else if(storiCountInWords < 60){
            message = "Stori is small, 60 words minimum"
        }
        else if(coverPicture.URL == "" && coverPicture.newURL == "" ){
            message = "Please add a cover picture for your stori"
        }else if(storiLocation.latitude == 0){
            message = "Please add a location to the stori"
        }else if(!isValiedDate()){
            message = "Please check the Date of Death"
        }
        return message
    }
    func isValiedDate() ->Bool {
        if(txtDateofDeath.text != ""){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let dateOfDeath:Date = dateFormatter.date(from: txtDateofDeath.text!)!
            let dateOfBirth:Date = dateFormatter.date(from: txtDateOfBirth.text!)!
            if(dateOfBirth > dateOfDeath ){
                return false
            }
        }else{
            return true
        }
        return true
    }
    //MARK: Calendar
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable copy, select all, paste
        if(action == #selector(TextToolBarDelegate.cancelPressed) || action == #selector(TextToolBarDelegate.nextPressed)){
            return true
        }
        if (txtDateofDeath.isFirstResponder || txtDateOfBirth.isFirstResponder) {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtStory.text.isEmpty {
            setPlaceholder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        if(textField.tag == 11){
            datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        }else if(textField.tag == 12){
        }
        addToolbar(textField:textField)
    }
    
    func addToolbar(textField :UITextField){
        toolBar = TextToolBar()
        
        toolBar?.toolBarDelegate = self
        textField.inputAccessoryView = toolBar
    }
    func cancelPressed() {
        self.view.endEditing(true)
    }
    func nextPressed() {
        
        if (txtDateofDeath.isFirstResponder){
            self.view.endEditing(true)
        }else if (txtDateOfBirth.isFirstResponder){
            txtDateofDeath.becomeFirstResponder()
        }
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" //Your date format
        if (txtDateofDeath.isFirstResponder){
            txtDateofDeath.text = dateFormatter.string(from: sender.date)
        }else if (txtDateOfBirth.isFirstResponder){
            txtDateOfBirth.text = dateFormatter.string(from: sender.date)
        }
    }
    //MARK: Navigate
    func navigateToHome(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    func popupEditGallery(){
        if(galleryController == nil){
            galleryController = storyboard!.instantiateViewController(withIdentifier: "EditGalleryImagesViewController") as! EditGalleryImagesViewController
            galleryController?.coverPic = coverPicture.URL
            galleryController?.gallery = self.storiImages
            addChildViewController(galleryController!)
            galleryController?.delegate = self
            view.addSubview((galleryController?.view)!)
            galleryController?.didMove(toParentViewController: self)
        }
        else{
            view.addSubview((galleryController?.view)!)
        }
    }
    
    func cancelToStoriDetails(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMapView(){
        self.performSegue(withIdentifier: "navigateToMapView", sender: self)
    }
}
//MARK: AlertDialoge
extension WriteStoriViewController:AlertViewDelegate{
    func alertDialoge(_ alertView: AlertView, listOfUrl: [UrlDetails], alertTitle text: String) {
        if(text == LINK){
            self.listOfLinkUrl = listOfUrl as! [LinkUrlDetails]
        }else if(text == VIDEO){
            self.listOfVideoUrl = listOfUrl as! [VideoUrlDetails]
        }
    }
}
//MARK: ImageDelegate
extension WriteStoriViewController:AddImageDelegate{
    func addCoverPicture(_ addImageDialoge: AddImageDialoge, addCoverPic button: UIButton) {
        imageDialoge.removeFromSuperview() //Remove popup
        let pickerViewController = Utilities.takePhoto(limit:1)
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    func addGalleryPicture(_ addImageDialoge: AddImageDialoge, addGalleryPic button: UIButton) {
        imageDialoge.removeFromSuperview()  //Remove popup
        
        let pickerViewController = Utilities.takePhoto(limit:6)
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    func removeAddImageDialoge(_ addImageDialoge: AddImageDialoge) {
        imageDialoge.removeFromSuperview() //Remove popup
    }
}

//MARK: TextViewDelegate
extension WriteStoriViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtStory.textColor == UIColor.lightGray {
            txtStory.text = nil
            txtStory.textColor = UIColor.black
        }
    }
}

//MARK: PhotoPicker
extension WriteStoriViewController:YMSPhotoPickerViewControllerDelegate{
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
        picker.dismiss(animated: true) {
            UIGraphicsBeginImageContext(image.size)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            self.coverPicture.newURL = Utilities.encodeImageToBase64(image: Utilities.resizeImage(image: rotatedImage!, newWidth: CGFloat(RESIZE_WIDTH)))
        }
    }
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        // Images you get here is PHAsset array, you need to implement PHImageManager to get UIImage data by yourself
        
        picker.dismiss(animated: true) {
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            
            
            for asset: PHAsset in photoAssets
            {
                let targetSize = PHImageManagerMaximumSize
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit , options: options, resultHandler: { (image, info) in
                    let imageDetails = UrlDetails()
                    imageDetails.newURL = Utilities.encodeImageToBase64(image: Utilities.resizeImage(image: image!, newWidth: CGFloat(RESIZE_WIDTH)))
                    self.storiImages.append(imageDetails)
                })
            }
        }
    }
}
//MARK: EditGalleryDelegate
extension WriteStoriViewController: EditGalleryDelegate{
    
    func editGalleryPicture(_ addImageDialoge: EditGalleryImagesViewController, coverPic: String, imageUrl: [UrlDetails], localImages: [UIImage],coverChanged:Bool) {
        self.storiImages = imageUrl
        if(coverChanged){
            coverPicture.newURL = coverPic
            coverPicture.id = 0
        }
        for image in localImages{
            
            let newImage = UrlDetails()
            newImage.newURL = Utilities.encodeImageToBase64(image: image)
            self.storiImages.append(newImage)
        }
    }
}
