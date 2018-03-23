import UIKit

@objc protocol TextToolBarDelegate: class{
    func cancelPressed()
    func nextPressed()
}

class TextToolBar: UIToolbar {
    
    weak var toolBarDelegate: TextToolBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeToolBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeToolBar()
    }
    func initializeToolBar(){
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = UIColor(red: 158 / 255, green: 144 / 255, blue: 104 / 255, alpha: 1)
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: toolBarDelegate, action: #selector(toolBarDelegate?.nextPressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: toolBarDelegate, action: #selector(toolBarDelegate?.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setItems([cancelButton, spaceButton, nextButton], animated: false)
        
        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }

}
