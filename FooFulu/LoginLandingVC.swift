//
//  LoginLandingVC.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit


class LoginLandingVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarDelegate,UITextFieldDelegate,SearchViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var arrFoodTypeSet = [String]()
    var arrFoodIcon = [UIImage]()
	var dealDetail:DealDetail!
	var businessData:Business!
	var lat:Double = 0.0
	var long:Double = 0.0
	var localTimeZone:String?
	var currentWeekDay:Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let date = Date()
		let calendar = Calendar.current
		currentWeekDay = calendar.component(.weekday, from: date)
		var localTimeZoneName: String { return TimeZone.current.identifier }
		localTimeZone = localTimeZoneName
		if (UserDefaults.standard.value(forKey: "CategorySelected") as? String) != nil {
            UserDefaults.standard.removeObject(forKey: "CategorySelected")
        }
        self.callCollectionView()
    }
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "searchScreenIdentifier"{
			let searchObj = segue.destination as! SearchViewController
			searchObj.delegate = self
		}
	}
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//		performSegue(withIdentifier: "searchScreenIdentifier", sender: self)
		let transition = CATransition()
		transition.duration = 0.5
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromTop
		self.navigationController!.view.layer.add(transition, forKey: nil)
		let writeView : SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
		self.navigationController?.pushViewController(writeView, animated: false)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		selectedIndexTab = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchString=textField.text!
		if !searchString.isEmpty{
			let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
			objAppDelegate?.makingRoot("enterApp")
		}
    }
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchString=textField.text!
		if !searchString.isEmpty{
			let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
			objAppDelegate?.makingRoot("enterApp")
		}
		return true
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
		collectionView.reloadData()
    }
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
//		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}

    func callCollectionView () {
        arrFoodTypeSet = ["Breakfast","Lunch","Dinner","Happy Hour"]
        arrFoodIcon = [#imageLiteral(resourceName: "breaffast"),#imageLiteral(resourceName: "lunch"),#imageLiteral(resourceName: "dinner"),#imageLiteral(resourceName: "happy-hr")]
        collectionView.reloadData()
    }
	
	func passDealIdToLastViewController(dealId:Int) {
		getDealDetails(dealId: dealId)
	}
	
	func passBussinessIDBack(bussinessId: Int, selectedLatitude: Double, selectedLongitude: Double) {
		getBusinessDetails(businessId: bussinessId, latitude: selectedLatitude, longitude: selectedLongitude)
	}
	
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		let indexOfTab: Int = (tabBar.items as NSArray?)!.index(of: item)
        let index = Int(indexOfTab)
		let _: [AnyHashable: Any] = [ "index" : Int(index) ]
        selectedIndexTab = indexOfTab
        let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        objAppDelegate?.makingRoot("enterApp")
    }
	
	
	func getDealDetails (dealId:Int) {
		let params:NSDictionary = [
			"dealId" : dealId
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getDealDetails, params: params) { (responseObject) -> Void in
			print(responseObject)
			do{
				self.dealDetail = try JSONDecoder().decode(DealDetail.self, from:responseObject)
				let objEditHomeDealVC :EditHomeDealVC = self.storyboard?.instantiateViewController(withIdentifier: "EditHomeDealVC") as! EditHomeDealVC
				objEditHomeDealVC.selectedDealDetail = self.dealDetail
//				objEditHomeDealVC.isComesFromLandingPage = true
				self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
			} catch let jsonError{
				print("error",jsonError)
			}
		}
	}
	func getBusinessDetails (businessId:Int,latitude:Double,longitude:Double) {
		let params:NSDictionary = [
			"bussinessId" : businessId,
			"latitude" : latitude,
			"longitude" : longitude,
			"day":currentWeekDay ?? "",
			"timeZone":localTimeZone ?? "i"
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getBussinessDetails, params: params) { (responseObject) -> Void in
			print(responseObject)
			do{
				self.businessData = try JSONDecoder().decode(Business.self, from:responseObject)
				let objHomeDayDetailEditVC :HomeDayDetailEditVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDayDetailEditVC") as! HomeDayDetailEditVC
				objHomeDayDetailEditVC.passBusinessData = self.businessData
//				objHomeDayDetailEditVC.isComesFromLandingPage = true
				self.navigationController?.pushViewController(objHomeDayDetailEditVC, animated: true)
			} catch let jsonError {
				print("error",jsonError)
			}
		}
	}
	func passBussinessDetailsBack(bussinessDetail: BusinessDetail) {
		if  super.guestUserOrNormal() {
			let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			present(alert, animated: true, completion: nil)
		} else {
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTypeDealVC") as! AddTypeDealVC
			nextViewController.selectedbusienessDetail = bussinessDetail
//			nextViewController.isComesFromLandingPage = true
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}
	}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFoodTypeSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let holdrView = cell.viewWithTag(1)!
        holdrView.backgroundColor = UIColor.clear
        let imgView = cell.viewWithTag(2) as! UIImageView
        imgView.image = arrFoodIcon[indexPath.row]
        let lblForDinner = cell.viewWithTag(3) as! UILabel
        lblForDinner.text = arrFoodTypeSet[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "headerView",
                                                                             for: indexPath)
            
            let textFieldSearch = headerView.viewWithTag(11) as! UITextField
            textFieldSearch.backgroundColor = UIColor.white
//            textFieldSearch.resignFirstResponder()
            return headerView
        default:
            return UICollectionReusableView ()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.size.width
        return CGSize(width: width/2 - 46, height: width/2 - 60)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set("\(arrFoodTypeSet[indexPath.row])", forKey: "CategorySelected")
        selectedIndexTab = 0
        let objAppDelegate : AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        objAppDelegate?.makingRoot("enterApp")
    }
    
    func enterApp()  {
        
    }
    
	

}
