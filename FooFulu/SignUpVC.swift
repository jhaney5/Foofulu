//
//  SignUpVC.swift
//  FooFulu
//
//  Created by netset on 11/15/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import GGLSignIn
import GoogleSignIn
import FacebookLogin
import FacebookCore
//import FBSDKCoreKit
//import FBSDKShareKit

class SignUpVC: BaseVC,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var btnForSelectOccasional: UIButton!
    @IBOutlet weak var textFldName: UITextField!
    @IBOutlet weak var textFldEmail: UITextField!
    @IBOutlet weak var textFldPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
	var selectedUrl:String!
	var navigationTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTextFields()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        btnSignUp.backgroundColor = Constant.Color.k_AppNavigationColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Sign Up"
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //UIApplication.shared.isStatusBarHidden = false
        
    }
    
    func setUpTextFields()
    {
        var i: Int = 0
        for subView: UIView in self.view.subviews
        {
            if (subView is UITextField)
            {
                let textfield: UITextField? = (subView as? UITextField)
                textfield?.underlined()
                textfield?.delegate = self
                textfield?.setValue(Constant.Color.k_AppTextFeildPlaceholderColor, forKeyPath: "_placeholderLabel.textColor")
                i = i + 1
            }
        }
    }
    
    func validations() -> String {
        
        self.view.endEditing(true)
        var str: String? = ""
        if textFldName.text?.count == 0 {
            str = "Please enter your name."
        }
        else if textFldEmail.text?.count == 0 {
            str = "Please enter your email."
        }
        else if !validateEmail(textFldEmail.text!) {
            str = "Please enter a valid email address."
        }
        else if textFldPassword.text?.count == 0 {
            str = "Please enter your new password."
        }
        else if (textFldPassword.text?.count)! < 8 {
            str = "Password must contain 8 characters."
        }
        return str!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       
        if textField.isEqual(textFldEmail)
        {
            if (textFldEmail.text?.count)! >= 36 && range.length == 0
            {
                return false
            }
            if  string.isEqual(" ")
            {
                return false
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == textFldName {
            textFldEmail.becomeFirstResponder()
        } else if textField == textFldEmail {
            textFldPassword.becomeFirstResponder()
        }  else if textField == textFldPassword {
            self.textFldPassword.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showWebViewIdentifier"{
			let webObj = segue.destination as! WebViewVC
			webObj.urlString = selectedUrl
			webObj.strForTitle = navigationTitle
		}
	}
    
    
    // MARK: - btn Act for SignUpVC
    
	@IBAction func termOfServiceButtonTapped(_ sender: Any) {
		navigationTitle = "Terms And Conditions"
		selectedUrl = "https://termsfeed.coam/terms-conditions/a5b74b65308d2930f2a429c4f6a3c535"
		performSegue(withIdentifier: "showWebViewIdentifier", sender: nil)
	}
	@IBAction func privacyPolicyButtonTapped(_ sender: Any) {
		navigationTitle = "Privacy Policy"
		selectedUrl = "https://termsfeed.com/privacy-policy/518a290895ceb1cc68f9b5d42be99949"
		performSegue(withIdentifier: "showWebViewIdentifier", sender: nil)

	}
	@IBAction func contentPolicyButtonTapped(_ sender: Any) {
		navigationTitle = "Content Policy"
		selectedUrl = ""
		performSegue(withIdentifier: "showWebViewIdentifier", sender: nil)
	}
	@IBAction func btnActForFacebookSignUp(_ sender: UIButton) {
        let loginManager = LoginManager()
		loginManager.loginBehavior = .web
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
        }
    }
    
    @IBAction func btnActForGoogleSignup(_ sender: UIButton) {
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
        
        self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: user.userID, fbname: user.profile.name, fbEmail: user.profile.email)
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google Disconnected")
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
//                    // self.loginWithSocialIntegration(url: GlobalConstantClass.serviceRequestUrl.k_loginWithFacebook, accessId: "\(String(format: accessToken.token.userId!))")
//
//                    //   self.loginWithSocialIntegration(url: GlobalConstantClass.serviceUrl.socialLogin, facebookId: dict.value(forKey: "id") as! String, fbProfileImage: dict.value(forKeyPath: "picture.data.url") as! String, fbname: dict.value(forKey: "name") as! String, fbGender: dict.value(forKey: "gender") as! String, fbEmail: dict.value(forKey: "email") as! String)
//
//                    self.loginWithSocialIntegration(url: Constant.WebServicesApi.socialLogin, facebookId: dict.value(forKey: "id") as! String, fbname: dict.value(forKey: "name") as! String, fbEmail: dict.value(forKey: "email") as! String)
//
//                }
//            })
//        }
//    }
    
    func loginWithSocialIntegration(url : String , facebookId: String, fbname:String,fbEmail:String) {
        let params = [
            "name": fbname,
            "email": fbEmail,
            "socialId": facebookId,
            "loginType": "iPhone",
			"deviceId":"sgergEG",
			"deviceType":"ios"
            ] as NSDictionary
        
        print(params)
        
        super.showAnloaderFunct(text: "Loading..")
        
        super.postMultipleArrayServiceWithParameters(requestUrl: url as String, params: params as NSDictionary, callback:{
            (responseObject) -> Void in
            print(responseObject)
            super.hideAnloaderFunct()
            let arrMut:NSMutableArray?
            arrMut = NSMutableArray.init()
            arrMut?.add(responseObject as! NSDictionary)
            let strId:String = ((arrMut?.value(forKey: "secretKey") as AnyObject).object(at: 0) as? String)!
            UserDefaults.standard.set(strId, forKey: "secretKey")
            UserDefaults.standard.synchronize()
//            let objAppDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//            objAppDelegate?.makingRoot("enterApp")
			let objLoginLandingVC :LoginLandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let nav = UINavigationController(rootViewController: objLoginLandingVC)
			appDelegate.window?.rootViewController = nav
        })
    }

    @IBAction func btnActForSignUp(_ sender: UIButton) {
        let message = validations()
        if message .isEmpty  {
            
            let params:NSDictionary = [
                "name":self.textFldName.text!,
                "password":self.textFldPassword.text!,
                "email":self.textFldEmail.text!,
                "deviceId":"dsfvd54vdsfsv",
                "deviceType":"iPhone"
            ]
            super.showAnloaderFunct(text: "Loading..")
            super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.signup, params: params) { (respnseObject) -> Void in
                print(respnseObject)
                super.hideAnloaderFunct()
                
                let arrMut:NSMutableArray?
                arrMut = NSMutableArray.init()
                arrMut?.add(respnseObject as! NSDictionary)
                
                let strId:String = ((arrMut?.value(forKey: "secretKey") as AnyObject).object(at: 0) as? String)!
                
                UserDefaults.standard.set(strId, forKey: "secretKey")
                UserDefaults.standard.synchronize()
                
                selectedIndexTab = 0
//                let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
//                objAppDelegate?.makingRoot("enterApp")
				let objLoginLandingVC :LoginLandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
				self.navigationController?.pushViewController(objLoginLandingVC, animated: true)
				
            }
        }
        else    {
            alertViewController(title: "", message: message)
        }
    //    let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
    //    objAppDelegate?.makingRoot("enterApp")
    }

    
    
    @IBAction func btnActForSendMeOcassionalEmailUpdates(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func btnActForSignIn(_ sender: UIButton) {
		if let navController = self.navigationController {
			navController.popViewController(animated: true)
		}
//		let viewControllers = self.navigationController!.viewControllers as [UIViewController]
//		for aViewController:UIViewController in viewControllers {
//			if aViewController.isKind(of: LoginVC.self) {
//				_ = self.navigationController?.popToViewController(aViewController, animated: true)
//			}
//		}
//        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
    
    @IBAction func btnActForTermsAndServices(_ sender: UIButton) {
		if let navController = self.navigationController {
			navController.popViewController(animated: true)
		}
//        let objWebViewVC :WebViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//        objWebViewVC.strForTitle = "Terms and Conditions"
//        self.navigationController?.pushViewController(objWebViewVC, animated: true)
        
    }
    
   
    
}
