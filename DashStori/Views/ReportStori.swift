//
//  ReportStori.swift
//  DashStori
//
//  Created by George on 07/06/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

protocol ReportAbuseDelegate {
    func report(_ reportAbuse:ReportStori,message:String)
    func removeAlertDialoge(_ reportStori:ReportStori)
}
class ReportStori: UIView {

    @IBOutlet weak var txtReportingReason: UITextView!
    var delegate:ReportAbuseDelegate! = nil
    
    //MARK: IBAction

    @IBAction func cancelAction(_ sender: Any) {
        delegate.removeAlertDialoge(self)
    }
    
    @IBAction func reportAction(_ sender: Any) {
        delegate.report(self, message: txtReportingReason.text)
    }
    
    func showAlert(){
        txtReportingReason.layer.borderWidth = 0.45
        txtReportingReason.layer.cornerRadius = 5.0
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window{
            window.addSubview(self)
        }
    }
}
