//
//  EditGalleryImagesViewController.swift
//  DashStori
//
//  Created by George on 09/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import YangMingShan

protocol EditGalleryDelegate {
    func editGalleryPicture(_ addImageDialoge:EditGalleryImagesViewController, coverPic: String,imageUrl:[UrlDetails], localImages:[UIImage],coverChanged:Bool)
}

class EditGalleryImagesViewController: BaseViewController {
    
    @IBOutlet weak var heightOfcollectionView: NSLayoutConstraint!
    @IBOutlet weak var imageGallery: UICollectionView!
    @IBOutlet weak var storiCoverPicture: UIImageView!
    @IBOutlet weak var addGalleryPictureAction: UIButton!
    
    var coverPic:String = ""
    var coverPageChanged:Bool = false
    var gallery:[UrlDetails] = []
    var localImages:[UIImage] = []
    var delegate:EditGalleryDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVariables()
        imageGallery.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: @IBAction
    @IBAction func updateAction(_ sender: Any) {
        cancelAction(self)
        delegate.editGalleryPicture(self, coverPic: coverPic, imageUrl: gallery, localImages: localImages,coverChanged: coverPageChanged)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        if(6 - gallery.count - localImages.count != 0){
//            coverPageChanged = false
            let pickerViewController = Utilities.takePhoto(limit:(6 - gallery.count - localImages.count))
            self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        }
    }
    
    @IBAction func addCoverPictureAction(_ sender: Any) {
        coverPageChanged = true
        let pickerViewController = Utilities.takePhoto(limit:1)
        self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
    }
    
    func setVariables(){
        if (coverPic != "") {
            let url = URL(string: IMAGE_URL + coverPic)
            storiCoverPicture.kf.setImage(with: url)
        }
        setcollectionViewHeight()
    }
    
    func setcollectionViewHeight(){
        if(gallery.count + localImages.count <= 0){
            heightOfcollectionView.constant =  0
        }else if(gallery.count + localImages.count <= 3){
            heightOfcollectionView.constant =  CGFloat(70)
        }else{
            heightOfcollectionView.constant =  CGFloat(140)
        }
    }
    
    //MARK: Delete
    func deletePicture(_ sender:UIDatePicker){
        if(sender.tag < gallery.count && gallery.count != 0){
            gallery.remove(at: sender.tag)
        }else{
            localImages.remove(at: ( sender.tag - gallery.count))
        }
        self.setcollectionViewHeight()
        imageGallery.reloadData()
    }
}

//MARK: CollectionViewDelegate
extension EditGalleryImagesViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (gallery.count + localImages.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editGalleryCollectionViewCell", for: indexPath as IndexPath) as! EditGalleryCollectionViewCell
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(deletePicture), for: .touchUpInside)
        if( indexPath.row < gallery.count){
            let picture = gallery[indexPath.row]
            if (picture.URL != "") {
                let url = URL(string: picture.URL)
                cell.galleryImage.kf.setImage(with: url)
            }
        }else{
            cell.galleryImage.image = localImages[(indexPath.row - gallery.count)]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65 , height: 65)
    }
}

//MARK: YMSPhotoPickerViewControllerDelegate
extension EditGalleryImagesViewController:YMSPhotoPickerViewControllerDelegate{
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
        
        
        picker.present(alertController, animated: true, completion: nil)
    }
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPicking image: UIImage!) {
        picker.dismiss(animated: true) {
            UIGraphicsBeginImageContext(image.size)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            if(self.coverPageChanged){
                self.storiCoverPicture.image = image
                self.coverPic = Utilities.encodeImageToBase64(image: Utilities.resizeImage(image: image!, newWidth: CGFloat(RESIZE_WIDTH)))
            }else{
                self.localImages.append(Utilities.resizeImage(image: image!, newWidth: CGFloat(RESIZE_WIDTH)))
                self.imageGallery.reloadData()
            }
        }
    }
    func photoPickerViewController(_ picker: YMSPhotoPickerViewController!, didFinishPickingImages photoAssets: [PHAsset]!) {
        
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
                    self.localImages.append(Utilities.resizeImage(image: image!, newWidth: CGFloat(RESIZE_WIDTH)))
                })
            }
            self.setcollectionViewHeight()
            self.imageGallery.reloadData()
        }
    }
}
