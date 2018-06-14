//
//  CommonUtility.swift
//  CC
//
//  Created by netset on 15/09/17.
//  Copyright © 2017 Netset. All rights reserved.
//

import UIKit
class CommonUtilities: NSObject {
    static let sharedInstance = CommonUtilities()
    class func showUnknownErrorAlert(_ controller:UIViewController,callback:(()->())? = nil){
        AlertUtility.showAlert(controller, title: nil, message: "Something went wrong, please try after sometime", cancelButton: "OK",buttons: nil){ (alertAction, index) in
            callback?()
        }
    }
    
	class func openSettings() {
		if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
			UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
		}
	}
    
    class func showUnknownErrorAlert(_ controller:UIViewController, retry:@escaping ()->()){
        AlertUtility.showAlert(controller, title: nil, message: "Something went wrong, please retry", cancelButton: "Retry", buttons: nil) { (alertAction, index) in
            retry()
        }
    }
    
    class func showComingSoonAlert(_ controller:UIViewController){
        AlertUtility.showAlert(controller, title: nil, message: "Coming Soon", cancelButton: "OK", buttons: nil, actions: nil)
    }
    
    struct EmailValidation {
        static func isValidEmail(email:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
    }
	
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private var activityRestorationIdentifier: String {
        return "NVActivityIndicatorViewContainer"
    }
    
    //MARK:- USER DEFAULT FUNCTION(S)
    func setValueToUserDefault(value :AnyObject,key:NSString)->Void {
        UserDefaults.standard.set(value, forKey:key as String)
        UserDefaults.standard.synchronize()
    }
}

class AlertUtility {
    static let CancelButtonIndex = -1;
    class func showAlert(_ onController:UIViewController!, title:String?,message:String? ) {
        showAlert(onController, title: title, message: message, cancelButton: "OK", buttons: nil, actions: nil)
    }
    
    /**
     - parameter title:        title for the alert
     - parameter message:      message for alert
     - parameter cancelButton: title for cancel button
     - parameter buttons:      array of string for title for other buttons
     - parameter actions:      action is the callback which return the action and index of the button which was pressed
     */
    
    class func showAlert(_ onController:UIViewController!, title:String?,message:String? = nil ,cancelButton:String = "OK",buttons:[String]? = nil,actions:((_ alertAction:UIAlertAction,_ index:Int)->())? = nil) {
        // make sure it would be run on  main queue
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: cancelButton, style: UIAlertActionStyle.cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            actions?(action,CancelButtonIndex)
        }
        alertController.addAction(action)
        if let _buttons = buttons {
            for button in _buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    let index = _buttons.index(of: action.title!)
                    actions?(action,index!)
                }
                alertController.addAction(action)
            }
        }
        onController.present(alertController, animated: true, completion: nil)
    }
}
