//
//  WebViewController.swift
//  DashStori
//
//  Created by QBurst on 27/09/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension WebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        Utilities.showActivityIndicatory()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Utilities.hideActivityIndicatory()
    }
}
