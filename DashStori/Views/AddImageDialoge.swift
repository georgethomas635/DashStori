//
//  AddImageDialoge.swift
//  DashStori
//
//  Created by George on 04/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

protocol AddImageDelegate {
    func addCoverPicture(_ addImageDialoge:AddImageDialoge,addCoverPic button:UIButton)
    func addGalleryPicture(_ addImageDialoge:AddImageDialoge,addGalleryPic button:UIButton)
    func removeAddImageDialoge(_ addImageDialoge:AddImageDialoge)
}

class AddImageDialoge: UIView {
    
    var delegate:AddImageDelegate! = nil
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        delegate.removeAddImageDialoge(self)
    }
    @IBAction func addGalleryPictureAction(_ sender: Any) {
        delegate.addGalleryPicture(self, addGalleryPic: sender as! UIButton)
    }
    @IBAction func addCoverPictureAction(_ sender: Any) {
        delegate.addCoverPicture(self, addCoverPic: sender as! UIButton)
    }
    
    func showAlert() {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(self)
        }
    }
}
