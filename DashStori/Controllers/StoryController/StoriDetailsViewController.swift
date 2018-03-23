//
//  StoriDetailsViewController.swift
//  DashStori
//
//  Created by George on 20/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class StoriDetailsViewController: BaseViewController {
    
    @IBOutlet weak var listOfDocuments: UIStackView!
    @IBOutlet weak var documentBackgroundView: UIView!
    @IBOutlet weak var linksBackgroundView: UIView!
    @IBOutlet weak var videoBackgroundView: UIView!
    @IBOutlet weak var mapBackgroundView: UIView!
    @IBOutlet weak var storiBackgroundView: UIView!
    
    @IBOutlet weak var videoList: UIStackView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var relatedLinksLabel: UILabel!
    @IBOutlet weak var listOfLinks: UIStackView!
    @IBOutlet weak var storiImage: UIImageView!
    @IBOutlet weak var imageGallery: UICollectionView!
    
    @IBOutlet weak var storiDescription: UITextView!
    @IBOutlet weak var authorPic: UIImageView!
    @IBOutlet weak var storiPublishedOn: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var storiTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorDetails: UIView!
    @IBOutlet weak var deleteStoriButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imagebackgroundView: UIView!
    @IBOutlet weak var firstVideoThumbnail: UIImageView!
    @IBOutlet weak var videoUrlList: UIStackView!
    @IBOutlet weak var editStoriButton: UIButton!
    
    var storiID:Int = 0
    var authorId:Int = 0 //TODO: check
    var storiLocation = CLLocationCoordinate2D()
    var videoThumbUrl:String = ""
    var storiDetails = StoriDetails()
    
    var reportStori: ReportStori! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .hybrid
        self.registerForKeyboardNotifications(scrollView: scrollView)
        setShadow()
        getStoriDetails()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications(scrollView: scrollView)
        super.viewWillAppear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "navigateToPublicProfile"){
            let authorDetails = segue.destination as! AuthorDetailsViewController
            authorDetails.authorID = authorId
        }else if(segue.identifier == "nativateToMap"){
            let locationCoordinates = segue.destination as! StoriLocationViewController
            locationCoordinates.storiLocation = storiLocation
            locationCoordinates.readOnlyMode = true
        }else if(segue.identifier == "natigateToEditStori"){
            let editStori = segue.destination as! WriteStoriViewController
            editStori.editMode = true
            editStori.storiId = storiID
            
            
        }
    }
    
    //MARK: API Call
    func callDeleteStoriApi(){
        Utilities.showActivityIndicatory()
        
        let manager = DashStoriManager()
        manager.deleteStori(storiID: storiID) {
            (data, error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let response = data as! BaseResponseModel
                if(response.success){
                    self.navigateToHome()
                }
                else{
                    self.showAlertMessage(errorMessage: response.message)
                }
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func getStoriDetails(){
        Utilities.showActivityIndicatory()
        let manager = DashStoriManager()
        manager.getStoriDetails(storiID: storiID){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let storiDetailsResponce = data as! StoriDetailsResponse
                
                if(storiDetailsResponce.storiData != nil){
                    
                    self.storiDetails = storiDetailsResponce.storiData!
                    
                    self.setVariablesfor(myStori: self.storiDetails.isMyStori,
                                         verified: self.storiDetails.verified)
                    self.setStori(details: self.storiDetails)
                    self.imageGallery.reloadData()
                }
            }else{
                Utilities.hideActivityIndicatory()
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func reportStoriAPI(withMessage:String){
        Utilities.showActivityIndicatory()
        let report = ReportAbuseRequest()
        report.reportAbuse(storiId: storiID, message: withMessage){
            (data, error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                self.navigateToHome()
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    //MARK: shareOnSocialMedia
    
    func shareOnSocialMedia (_ sender: UIButton?, _ text: String, _ image: UIImage){
        
        if let myWebsite = NSURL(string: BASE + "stori/" + String(self.storiID) ) {
            
            let objectsToShare = [text, image, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Navigate
    func navigateToAuthorDetails(){
        self.performSegue(withIdentifier: "navigateToPublicProfile", sender: self)
    }
    func navigateToHome(){
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Stori Details
    func setStori(details:StoriDetails){
        storiTitle.text = details.storiTitle
        date.text = getDate(dob: details.dateOfBirth, dod: details.dateOfDeath)
        let picture = details.authorPicUrl
        if (picture != "") {
            let url = URL(string: picture)
            authorPic.kf.setImage(with: url)
        }
        authorId = details.authorID
        authorName.text = details.authorName
        storiDescription.text = details.storyDetails
        storiPublishedOn.text = details.publishedOn

        Utilities.createCircularImage(imageview: authorPic)
        if(details.location.count != 0){
            if( details.location[0].latitude != 0.0){
                storiLocation.latitude = details.location[0].latitude
                storiLocation.longitude = details.location[0].longitude
                dropPin(location: storiLocation)
            }
        }
        setVideoURL(urlList:details.videoUrl)
        
        if((details.linkUrl.count) > 0){ //Links
            relatedLinksLabel.isHidden = false
            linksBackgroundView.isHidden = false
            for link in details.linkUrl{
                createLabel(link: link,stackView: listOfLinks,hyperLinkText: "")
            }
            
        }
        else{
            relatedLinksLabel.isHidden = true
            linksBackgroundView.isHidden = true
        }
        
        if(details.listOfDocuments.count > 0){ //Documents
            documentBackgroundView.isHidden = false
            for documentUrl in details.listOfDocuments{
                createLabel(link: documentUrl.url,stackView: listOfDocuments,hyperLinkText: documentUrl.docName)
            }
        }else{
            documentBackgroundView.isHidden = true
        }
    }
    
    func setVideoURL(urlList:[VideoThumbnail]){
        if((urlList.count) > 0){
            relatedLinksLabel.isHidden = false
            var videoThumbnailFlag = true
            for link in urlList {
                if(videoThumbnailFlag && link.thumbnail != ""){
                    videoThumbUrl = link.videoURL
                    let url = URL(string: link.thumbnail)
                    firstVideoThumbnail.kf.setImage(with: url)
                    firstVideoThumbnail.isHidden = false
                    thumbnailButton.isHidden = false
                    videoThumbnailFlag = false
                }else{
                    createLabel(link: link.videoURL,stackView: videoUrlList,hyperLinkText: "")
                }
            }
            
        }else{
            videoBackgroundView.isHidden = true
        }
        
    }
    func getDate(dob:String,dod:String) ->String{
        if(dod == ""){
            return dob
        }else{
            return (dob + " - " + dod)
        }
    }
    
    func setVariablesfor(myStori:Bool,verified:Bool) {
        firstVideoThumbnail.isHidden = true
        thumbnailButton.isHidden = true
        if(myStori == false || verified == false) {
            editStoriButton.isHidden = true
            deleteStoriButton.isHidden = true
        }else{
            editStoriButton.isHidden = false
            deleteStoriButton.isHidden = false
        }
    }
    
    //MARK Shadow
    func setShadow(){
        Utilities.setShadow(forView: imagebackgroundView)
        Utilities.setShadow(forView: storiBackgroundView)
        Utilities.setShadow(forView: mapBackgroundView)
        Utilities.setShadow(forView: videoBackgroundView)
        Utilities.setShadow(forView: linksBackgroundView)
        Utilities.setShadow(forView: documentBackgroundView)
    }
    
    //MARK: IBAction
    @IBAction func moveRightAction(_ sender: Any) {
        let currentCell = imageGallery.indexPathsForVisibleItems[0].item
        if currentCell < imageGallery.numberOfItems(inSection: 0)-1 {
            let indexPath = IndexPath(row:  currentCell + 1, section: 0)
            imageGallery.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
        }
    }
    @IBAction func thumbnailAction(_ sender: Any) {
        if let url = NSURL(string: videoThumbUrl) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func reportAbuseAction(_ sender: Any) {
        if(storiDetails.reported){
            showAlertMessage(errorMessage: "You have already reported this stori")
        }else{
            showReportAbuseDialoge()
        }
    }
    
    @IBAction func shareStoriAction(_ sender: UIButton?) {
        
        let textToShare = "Checkout the link  from Dashstori to view the story of " + storiDetails.storiTitle
        var imageToShare: UIImage! = nil
        
        if storiDetails.images.count > 0 {
            let picture = storiDetails.images[0]
            let url = URL(string: IMAGE_URL + picture)
            let imageView = UIImageView()
            
            imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil,
                completionHandler: { (image, error, cacheType, url) in
                    
                    imageToShare = image ?? #imageLiteral(resourceName: "logo")
                    self.shareOnSocialMedia(sender, textToShare, imageToShare)
            })
        }
        else {
            imageToShare = #imageLiteral(resourceName: "logo")
            shareOnSocialMedia(sender, textToShare, imageToShare)
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        showAlertMessageWithAction(message: CONFORMATION_DELETION)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "natigateToEditStori", sender: self)
    }
    @IBAction func viewMapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "nativateToMap", sender: self)
    }
    @IBAction func moveLeftAction(_ sender: Any) {
        let currentCell = imageGallery.indexPathsForVisibleItems[0].item
        if currentCell > 0 {
            let indexPath = IndexPath(row:  currentCell - 1, section: 0)
            imageGallery.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
        }
    }
    
    @IBAction func authorDetailsAction(_ sender: Any) {
        navigateToAuthorDetails()
    }
    
    //MARK: Create Label
    func createLabel(link:String,stackView:UIStackView,hyperLinkText:String){
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: (stackView.bounds.width - 25), height: 15))
        textView.isEditable = false
        textView.isScrollEnabled = false
        var styledText = NSMutableAttributedString()
        if(hyperLinkText == ""){
            styledText = NSMutableAttributedString(string: link)
            let attributes:[String: Any] = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
                NSLinkAttributeName:NSURL(string: link.trimmingCharacters(in: .whitespaces)) as Any,
                NSForegroundColorAttributeName: UIColor.blue
            ]
            styledText.setAttributes(attributes, range: NSMakeRange(0, link.characters.count))
        }else{
            styledText = NSMutableAttributedString(string: hyperLinkText)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSLinkAttributeName:NSURL(string: link.trimmingCharacters(in: .whitespaces))!, NSForegroundColorAttributeName: UIColor.blue]
            styledText.setAttributes(attributes, range: NSMakeRange(0, hyperLinkText.characters.count))
        }
        
        textView.attributedText = styledText
        textView.font = UIFont (name: "Akrobat-Regular", size: 15)
        stackView.addArrangedSubview(textView)
    }
    
    //MARK: Mapview
    func dropPin(location: CLLocationCoordinate2D){
        // Add annotation:
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        //Focus change
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, 150000, 150000)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    //MARK: AlertMessage
    func showAlertMessageWithAction(message:String){
        let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: OK, style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.callDeleteStoriApi()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showReportAbuseDialoge(){
        reportStori = Bundle.main.loadNibNamed("ReportStoriView", owner: self, options: nil)?[0] as? ReportStori
        reportStori.frame = self.view.bounds
        reportStori.showAlert()
        reportStori.delegate = self
    }
}

//MARK: CollectionViewDelegate
extension StoriDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return storiDetails.images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath as IndexPath) as! GalleryCollectionViewCell
        let picture = storiDetails.images[indexPath.row]
        if (picture != "") {
            let url = URL(string: IMAGE_URL + picture)
            cell.storiPicture.kf.setImage(with: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageGallery.bounds.width , height: imageGallery.bounds.height)
    }
}

extension StoriDetailsViewController: MKMapViewDelegate{
    
}

//MARK: ReportStori
extension StoriDetailsViewController:ReportAbuseDelegate{
    func report(_ reportAbuse: ReportStori, message: String) {
        if(message != ""){
            reportStoriAPI(withMessage:message)
            reportStori.removeFromSuperview()
        }
    }
    func removeAlertDialoge(_ reportStori: ReportStori) {
        reportStori.removeFromSuperview() //Remove popup
    }
}

