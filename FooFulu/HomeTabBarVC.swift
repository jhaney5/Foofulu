//
//  HomeTabBarVC.swift
//  FooFulu
//
//  Created by netset on 11/7/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class HomeTabBarVC: UITabBarController,UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		Constant.imageSet.originalImage = nil
		self.selectedIndex = selectedIndexTab
		self.delegate = self
		self.automaticallyAdjustsScrollViewInsets = false
	}
	
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("did select delegate called")
        selectedIndexTab = tabBarController.selectedIndex
		  let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
			rootView.popToRootViewController(animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("should select delegate called")
       let viewController = tabBarController.viewControllers?[selectedIndexTab] as! UINavigationController
		viewController.popToRootViewController(animated: true)
        return true
    }
	
	

	

}
