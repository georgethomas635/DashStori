//
//  HeaderView.swift
//  DashStori
//
//  Created by George on 29/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func showSlideMenu(_ headerMenu: HeaderView)
}

class HeaderView: UIView {

    var delegate:SlideMenuDelegate! = nil
    
    @IBAction func burgerButtonClick(_ sender: Any) {
        delegate.showSlideMenu(self)
    }
}
