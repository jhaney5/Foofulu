//
//  AppDelegate.swift
//  FooFulu
//
//  Created by netset on 11/2/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import CoreLocation
import GGLSignIn
import FirebaseDynamicLinks
import Firebase
import GoogleSignIn
import GooglePlaces
import Branch

//import GooglePlaces
//import GooglePlacePicker

var selectedIndexTab: Int = 0
var searchString : String = ""
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		UIApplication.shared.statusBarStyle = .lightContent
		// ====================================== BRANCH DEEPLINKING  =============================
		Branch.getInstance().setDebug()
		Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let dict = (params! as NSDictionary)
			let dealId = dict.value(forKey: "dealId")
			if dealId != nil {
				UserDefaults.standard.set(dealId, forKey: "dealId")
			let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
				selectedIndexTab = 0
			self.window?.rootViewController = objMain
			}else if let busienessId = dict.value(forKey: "bussinessId"){
				UserDefaults.standard.set(busienessId, forKey: "bussinessId")
				let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
				selectedIndexTab = 0
				self.window?.rootViewController = objMain
			}else {
				
			}

		}
		//============================= IQKeyboardManager ==========================//
		IQKeyboardManager.sharedManager().enable = true
		IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
		
		//============================= Facebook ==========================//
		SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		// ==================== Google Plus =====================
		// Initialize sign-in
		var configureError: NSError?
		GGLContext.sharedInstance().configureWithError(&configureError)
		GMSPlacesClient.provideAPIKey("AIzaSyAuqTLyoIk0q1b-4JHAXAQ254FduQZ4vdk")
		FIRApp.configure()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().clipsToBounds = false
		UINavigationBar.appearance().titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Arial", size: 16)!,
															 NSForegroundColorAttributeName: UIColor.white])
		//        self.window?.backgroundColor = .clear
		UINavigationBar.appearance().tintColor = UIColor.white
		UINavigationBar.appearance().barTintColor = Constant.Color.k_AppNavigationColor
		UINavigationBar.appearance().backgroundColor = Constant.Color.k_AppNavigationColor
		selectedIndexTab = 0
		
		if (UserDefaults.standard.value(forKey: "secretKey") as? String == nil) ||  UserDefaults.standard.value(forKey: "secretKey") as! String == generalStrings.guestSecretKey.rawValue {
			self.makingRoot("initial")
		} else {
			self.makingRoot("enterApp")
		}
		return true
	}
	
	func makingRoot(_ strRoot: String) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if (strRoot == "initial") {
			selectedIndexTab = 0
			let objMain: UIViewController? = storyboard.instantiateViewController(withIdentifier: "LoginVC")
			let nav = UINavigationController(rootViewController: objMain!)
			window?.rootViewController = nav
		} else {
			if let viewController = window?.rootViewController as? UINavigationController {
				let presentedViewController = viewController.childViewControllers.last
				if (presentedViewController?.isKind(of: LoginLandingVC.self))!{
					let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
					window?.rootViewController = objMain
				}else{
					let objMain: LoginLandingVC = storyboard.instantiateViewController(withIdentifier: "LoginLandingVC") as! LoginLandingVC
					let nav = UINavigationController(rootViewController: objMain)
					window?.rootViewController = nav
				}
			}
			window?.makeKeyAndVisible()
			UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in })
		}
	}
	
	// for login facebook
	internal func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		Branch.getInstance().application(app, open: url, options: options)
		let appId = SDKSettings.appId
		if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
			return SDKApplicationDelegate.shared.application(app, open: url, options: options)
		}else
		{
			return GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,   annotation: options[UIApplicationOpenURLOptionsKey.annotation])
		}
		return true
	}
	
	
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
			  withError error: Error!) {
		if let error = error {
			print("\(error.localizedDescription)")
			
			NotificationCenter.default.post(
				name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
			
		} else {
			// Perform any operations on signed in user here.
			_ = user.userID                  // For client-side use only!
			_ = user.authentication.idToken // Safe to send to the server
			let fullName = user.profile.name
			_ = user.profile.givenName
			_ = user.profile.familyName
			_ = user.profile.email
			
			NotificationCenter.default.post(
				name: Notification.Name(rawValue: "ToggleAuthUINotification"),
				object: nil,
				userInfo: ["statusText": "Signed in user:\n\(String(describing: fullName))"])
			
		}
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
	
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		Branch.getInstance().continue(userActivity)
		guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
			let url = userActivity.webpageURL,
			let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
				return false
		}
		return true
	}
}

