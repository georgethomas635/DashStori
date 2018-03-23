	  //
//  BaseNavigationViewController.swift
//  DashStori
//
//  Created by George on 30/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class BaseNavigationViewController: UINavigationController, UINavigationControllerDelegate,SlideMenuDelegate {
    
    var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupHeader(){
        
        headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?[0] as! HeaderView
        headerView.delegate = self
        self.view.addSubview(headerView)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        if let vc = viewController as? BaseViewController, viewController is BaseViewController {
            headerView.isHidden = vc.isMenuHeaderHidden()
        }
    }
    func showSlideMenu(_ headerMenu: HeaderView) {
        self.slideMenuController()?.openLeft()
    }
}

extension BaseNavigationViewController:SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        if let viewController = self.topViewController {
            viewController.view.endEditing(true)
        }
    }
}
