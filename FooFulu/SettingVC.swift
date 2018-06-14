//
//  SettingVC.swift
//  FooFulu
//
//  Created by netset on 11/6/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GGLSignIn
import GoogleSignIn

class SettingVC: BaseVC,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var arrForTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.backBtnWithNavigationTitle(title : "Settings")
        // UIApplication.shared.setStatusBarHidden(false, with: .none)
        if super.guestUserOrNormal() {
            arrForTitle = ["About Us","Terms and Conditions","Privacy Policy","Contact Us"]
        } else {
            arrForTitle = ["About Us","Terms and Conditions","Privacy Policy","Contact Us","Logout"]
        }
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let lblForTitle = cell.viewWithTag(100) as! UILabel
        cell.backgroundColor = UIColor.clear
        lblForTitle.text = arrForTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
//        let objSettingDetailVC :SettingDetailVC = storyboard?.instantiateViewController(withIdentifier: "SettingDetailVC") as! SettingDetailVC
//        if indexPath.row == 0 {
//            Constant.GlobalVariables.checkForSetting = "Push Notifications"
//            self.navigationController?.pushViewController(objSettingDetailVC, animated: true)
//        }
		 if indexPath.row == 0  {
			let title = arrForTitle[indexPath.row]
			navigateToWebViewController(title: title, url: "")
		}else if  indexPath.row == 1  {
			let title = arrForTitle[indexPath.row]
			navigateToWebViewController(title: title, url: "https://termsfeed.com/terms-conditions/a5b74b65308d2930f2a429c4f6a3c535")
		}else if indexPath.row == 2 {
			let title = arrForTitle[indexPath.row]
			navigateToWebViewController(title: title, url: "https://termsfeed.com/privacy-policy/518a290895ceb1cc68f9b5d42be99949")
		}else if indexPath.row == 3{
            self.performSegue(withIdentifier: "contactScreenIdentifier", sender: nil)
        }  else {
            self.logOut()
        }
    }
	
	func navigateToWebViewController(title:String,url:String) {
		let objWebViewVC :WebViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
		objWebViewVC.strForTitle = title
		objWebViewVC.urlString = url
		self.navigationController?.pushViewController(objWebViewVC, animated: true)
	}
	
    func logOut() {
        let alertForLogout = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertForLogout.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            super.showAnloaderFunct (text: "Logging out..")
            super.getService(requestURL: Constant.WebServicesApi.logoutApi, callBack: { (responseObject) -> Void in
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                GIDSignIn.sharedInstance().signOut()
                UserDefaults.standard.set(nil, forKey: "secretKey")
                UserDefaults.standard.synchronize()
                let objAppDelegate:AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.makingRoot("initial")
            })
        }))
        alertForLogout.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        present(alertForLogout, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
