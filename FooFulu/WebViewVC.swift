//
//  WebViewVC.swift
//  FooFulu
//
//  Created by netset on 11/13/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class WebViewVC: BaseVC {
    var strForTitle:String!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
	var urlString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.backBtnWithNavigationTitle(title: strForTitle as String)
        let url = NSURL (string: urlString)
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
        webView.isOpaque = false
        webView.backgroundColor = UIColor .white
        activityView?.tintColor = Constant.Color.k_AppNavigationColor
        activityView? .startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityView? .stopAnimating()
        activityView?.isHidden = true
        activityView? .removeFromSuperview()
    }

   

}
