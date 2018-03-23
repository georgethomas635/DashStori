//
//  AlertInput.swift
//  DashStori
//
//  Created by George on 22/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

protocol AlertInputDelegate {
    func alertInput(_ alertInput:AlertInput, addButtonClick button:UIButton)
    func alertInput(_ alertInput:AlertInput, closeButtonClick button:UIButton)
}

class AlertInput: UIView {
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    var delegate:AlertInputDelegate! = nil
    var actionButtonFlag:Bool = true  //true -> add, false -> close
    
    @IBAction func actionButtonClick(_ sender: Any) {
        actionButtonFlag = !actionButtonFlag
        if(actionButtonFlag){            
            delegate.alertInput(self, closeButtonClick: actionButton)
            actionButton.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
            
        }else{
            if inputText.text != "" {
                delegate.alertInput(self, addButtonClick: actionButton)
                actionButton.setBackgroundImage(#imageLiteral(resourceName: "remove"), for: .normal)
            }else{
                actionButtonFlag = !actionButtonFlag
            }
        }
    }
    
}
