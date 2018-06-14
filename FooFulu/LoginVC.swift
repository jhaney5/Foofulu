//
//  LoginVC.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import GGLSignIn
import GoogleSignIn
import FacebookLogin
import FacebookCore
//import FBSDKShareKit

class LoginVC: BaseVC,GIDSignInDelegate,GIDSignInUIDelegate {

    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button application
    
    @IBAction func btnActForLetsGo(_ sender: Any) {
       // guestSecretKey
        UserDefaults.standard.set(generalStrings.guestSecretKey.rawValue , forKey: "secretKey")
        UserDefaults.standard.synchronize()
        let objLoginLandingVC :LoginLandingVC = storyboard?.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
        self.navigationController?.pushViewController(objLoginLandingVC, animated: true)
    }
    
    
 //   logIn([.email, .publicProfile], viewController: self, completion:{ loginResult in
    @IBAction func btnActForFacebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.email,.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success (let accessToken):
                print("ACCESS TOKEN \(accessToken.token.authenticationToken)")
           //     super.showHUD(view: self.view)
                let fbRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"])
                fbRequest.start{(urlResponse, requestResult) in
                    
                    switch requestResult {
                    case .failed(let error):
           //             super.hideHUD()
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        if let responseDictionary: NSDictionary = graphResponse.dictionaryValue as NSDictionary? {
                            //  print(responseDictionary)
                            self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: responseDictionary.value(forKey: "id") as? String ?? "", fbname: responseDictionary.value(forKey: "name") as? String ?? "", fbEmail: responseDictionary.value(forKey: "email") as? String ?? "")
                        }
                    }
               // })
            }
        }
        }//)
    }
    
//    func getFBUserData() {
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//
//                    let dict = result as! NSDictionary
//                    print(result!)
//                    print(dict.value(forKeyPath: "picture.data.url")!)
//
//                    let email = dict.value(forKey: "email") as? String
//                    if email == nil{
//                        self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: dict.value(forKey: "id") as! String, fbname: dict.value(forKey: "name") as! String, fbEmail: "")
//                    }else{
//                        self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: dict.value(forKey: "id") as! String, fbname: dict.value(forKey: "name") as! String, fbEmail: email!)
//                    }
//                }
//            })
//        }
//    }
    
    func loginWithSocialIntegration(url : String , facebookId: String, fbname:String,fbEmail:String) {
        let params = [
            "name": fbname,
            "email": fbEmail,
            "socialId": facebookId,
			"deviceId":"123456",
            "loginType": "Social",
			"deviceType":"iphone"
            ] as NSDictionary
        
        print(params)
        super.showAnloaderFunct(text: "Loading..")
        super.postMultipleArrayServiceWithParameters(requestUrl: url as String, params: params as NSDictionary, callback:{
            (responseObject) -> Void in
            print(responseObject)
            super.hideAnloaderFunct()
            let secretKey = responseObject["secretKey"] as! String
			UserDefaults.standard.set(secretKey , forKey: "secretKey")
            UserDefaults.standard.synchronize()
//            let objAppDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//            objAppDelegate?.makingRoot("enterApp")
			let objLoginLandingVC :LoginLandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let nav = UINavigationController(rootViewController: objLoginLandingVC)
			appDelegate.window?.rootViewController = nav

//			self.navigationController?.pushViewController(objLoginLandingVC, animated: true)
        })
    }
	
    @IBAction func btnActForGoogleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
         if let error = error {
             print(error.localizedDescription)
             return
        }
       let authentication = user.authentication
       print("Access token:", authentication?.accessToken! as Any)
       // self.loginWithSocialIntegration(url: GlobalConstantClass.serviceRequestUrl.k_loginWithGooglePlus, accessToken: authentication!.accessToken)
       // GIDSignIn.sharedInstance().signOut()

        
       // let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
       // objAppDelegate?.makingRoot("enterApp")
        print(user.userID)
        self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: user.userID, fbname: user.profile.name, fbEmail: user.profile.email)
    
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google Disconnected")
    }
    
    @IBAction func btnActForEmailLogin(_ sender: Any) {
        
        let objEmailLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC")
//        let transition = CATransition()
//        transition.duration = 0.8
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = "reveal"
//        transition.subtype = "fromRight"
//        self.navigationController?.view?.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(objEmailLoginVC!, animated: true)
        
    }
    
    

}
