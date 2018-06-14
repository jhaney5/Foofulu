//
//  EmailLoginVC.swift
//  FooFulu
//
//  Created by netset on 11/24/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class EmailLoginVC: BaseVC,UITextFieldDelegate,UIAlertViewDelegate {

    @IBOutlet weak var textFldEmail: UITextField!
    @IBOutlet weak var textFldPassword: UITextField!
    
    @IBOutlet weak var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.transition(with: self.imgLogo,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.imgLogo.image = #imageLiteral(resourceName: "AppLogo") },
                          completion: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.setUpTextFields()
    }
    
    func setUpTextFields()
    {
        var i: Int = 0
        var imagesArray = NSArray()
        imagesArray = [#imageLiteral(resourceName: "emailIcon"),#imageLiteral(resourceName: "Password")]
        for subView: UIView in self.view.subviews
        {
            if (subView is UITextField)
            {
                let textfield: UITextField? = (subView as? UITextField)
                textfield?.delegate = self
                textfield?.setImageLeftSideOnTextfield(image: imagesArray[i] as! UIImage)
                i = i + 1
                
                textfield?.setValue(Constant.Color.k_AppTextFeildPlaceholderColor, forKeyPath: "_placeholderLabel.textColor")
            }
        }
    }
    
    func validations() -> String {
        self.view.endEditing(true)
        var str: String? = ""
        if textFldEmail.text?.characters.count == 0 {
            str = "Please enter your email."
        }
        else if !validateEmail(textFldEmail.text!) {
            str = "Please enter a valid email address."
        }
        else if textFldPassword.text?.characters.count == 0 {
            str = "Please enter your password."
        }
//        else if  textFldPassword.text!.characters.count < 8{
//            str = "Password is not correct."
//        }
        return str!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: button action
    
    @IBAction func buttonActForManualLogin(_ sender: Any) {
        
        if validations().isEmpty {
            
            let params:NSDictionary = [
                                        "email": self.textFldEmail.text!,
                                        "password":self.textFldPassword.text!,
                                        "deviceId" : "dsfvd54vdsfsv",
                                        "deviceType": "iPhone"
                                      ]
            super.showAnloaderFunct(text: "Loading..")
            
            self.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.login, params: params, callback: { (responseObject) -> Void in
                
                print(responseObject)
                
                super.hideAnloaderFunct()
                
            // var data : Data? = NSKeyedArchiver.archivedData(withRootObject: responseObject as? NSDictionary)
            //    let returnData:String = String(data: data!, encoding: .utf8)!
                
                let arrMut:NSMutableArray?
                arrMut = NSMutableArray.init()
                arrMut?.add(responseObject as! NSDictionary)
                let strId:String = ((arrMut?.value(forKey: "secretKey") as AnyObject).object(at: 0) as? String)!
                UserDefaults.standard.set(strId, forKey: "secretKey")
                UserDefaults.standard.synchronize()
//                let objAppDelegate:AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//                objAppDelegate?.makingRoot("enterApp")
				let objLoginLandingVC :LoginLandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
				let appDelegate = UIApplication.shared.delegate as! AppDelegate
				let nav = UINavigationController(rootViewController: objLoginLandingVC)
				appDelegate.window?.rootViewController = nav
            })
            
        } else {
            self.alertViewController(title: "Alert", message: validations())
            
        }
    }
    
    @IBAction func bttnActForPassword(_ sender: Any) {
        self.callForAlertController()
    }
    
    func callForAlertController () {
        let alertController = UIAlertController(title: "Forgot Password!", message: "Enter your email to change password.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
            alert -> Void in
            
            let textFieldEmail = alertController.textFields![0] as UITextField
            textFieldEmail.keyboardType = .emailAddress
            if textFieldEmail.text?.characters.count == 0 {

                let alert:UIAlertView = UIAlertView(title: "Alert", message: "Please enter your email.", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                alert.show()
                
            }
            else if !super.validateEmail(textFieldEmail.text!) {
                
                let alert:UIAlertView = UIAlertView(title: "Alert", message: "Please enter a valid email address.", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                alert.show()
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your email"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.callForAlertController()
    }
    
    @IBAction func btnActForSignUp(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
//        let transition = CATransition()
//        transition.duration = 0.8
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = "reveal"
//        transition.subtype = "fromRight"
//        self.navigationController?.view?.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(signUpVC!, animated: true)
    }
    
	

}
