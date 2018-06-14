//
//  AddFirstDealVC.swift
//  FooFulu
//
//  Created by netset on 11/6/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
class AddFirstDealVC: UIViewController {
	//MARK:- OUTLET(S)
    @IBOutlet weak var lblForDeal: UILabel!
    @IBOutlet weak var btnAddAnotherDeal: UIButton!
    @IBOutlet weak var lblDealDetail: UILabel!
    @IBOutlet weak var imgViewDeal: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
	//MARK:- CONSTANT(S)
	var isDealAdded:DealData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setNavigationTitleAndColor()
		showDealAddedPopPupBasedOnUser()
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	//MARK:- PRIVATE METHOD(S)
	fileprivate func showDealAddedPopPupBasedOnUser(){
		if isDealAdded.firstDeal ?? false{
			lblForDeal.text = "Your First Deal!"
			imgViewDeal.image = #imageLiteral(resourceName: "cake")
			lblDealDetail.text = "Woohoo! People come to Foofulu looking for deals like the one you just added. The Foofulu community appreciates you!"
		} else {
			lblForDeal.text = "Deal Added!"
			imgViewDeal.image = #imageLiteral(resourceName: "greenCheck")
			lblDealDetail.text = ""
		}
	}
	
	fileprivate func setNavigationTitleAndColor(){
		self.navigationItem.leftBarButtonItem?.title = "back"
		btnAddAnotherDeal.borderLayerColor()
		btnClose.borderLayerColor()
		self.navigationItem.setHidesBackButton(true, animated:true)
	}
	
    // MARK:- IBACTION(S)
    @IBAction func btnActforAddAnotherDeal(_ sender: Any) {
        selectedIndexTab = 1
        Constant.GlobalVariables.checkForDealEdit = nil
        let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
		let objMain: UITabBarController? = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
		objAppDelegate?.window?.rootViewController = objMain
    }
    
    @IBAction func btnActForClose(_ sender: Any) {
        if Constant.GlobalVariables.checkForDealEdit != nil {
			var isValue = false
            Constant.GlobalVariables.checkForDealEdit = nil
			let viewControllers = self.navigationController!.viewControllers as [UIViewController]
			for aViewController:UIViewController in viewControllers {
				if aViewController.isKind(of: EditHomeDealVC.self) {
					isValue = true
					NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil)
					_ = self.navigationController?.popToViewController(aViewController, animated: true)
				}
			}
			if !isValue{
				selectedIndexTab = 0
				let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				let objMain: UITabBarController? = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
				objAppDelegate?.window?.rootViewController = objMain
			}
        } else {
            selectedIndexTab = 0
            let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
			let objMain: UITabBarController? = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
			objAppDelegate?.window?.rootViewController = objMain
        }        
    }
}
