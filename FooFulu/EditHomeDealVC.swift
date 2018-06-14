
//
//  EditHomeDealVC.swift
//  FooFulu
//
//  Created by netset on 11/7/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import CoreLocation
import Branch

class EditHomeDealVC: BaseVC,UIScrollViewDelegate,CLLocationManagerDelegate {
	
	@IBOutlet weak var scrollViewImage: UIScrollView!
	var arrMenuIconList = NSArray()
	@IBOutlet weak var lblPaging: UILabel!
	@IBOutlet weak var layoutForScrollHeight: NSLayoutConstraint!
	@IBOutlet weak var viewAllForOptionButton: UIButton!
	@IBOutlet weak var vwLike: UIView!
	@IBOutlet weak var lblTimePassedForDaysAgo: UILabel!
	@IBOutlet weak var lblTimePassLastVerified: UILabel!
	@IBOutlet weak var lblCreatedName: UILabel!
	@IBOutlet weak var lblLastVerifiedName: UILabel!
	@IBOutlet weak var lblPizzaOrderName: UILabel!
	@IBOutlet weak var btnVerifyCount: FooFuluButton!
	@IBOutlet weak var imgLikeUnlike: UIImageView!
	@IBOutlet weak var buttonForVerification: UIButton!
	var arrayForEditHomeDealVC = NSDictionary()
	var arrayForOtherProfileId = NSDictionary()
	var otherProfileData:OtherProfileDetail!
	var intDealId = Int()
	var locationManager = CLLocationManager()
	var latitude:Double! = nil
	var longitude:Double! = nil
	var localTimeZone:String?
	var isComesFromLandingPage = false

	var selectedDealDetail:DealDetail!
	@IBOutlet weak var stackViewForDaysOfWeek: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.removeObserver(self, name: Notification.Name("RefreshNotification"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("RefreshNotification"), object: nil)
		
		loadDidLoadData()
		
	}
	
	@IBAction func sscrollTapAction(_ sender: Any) {
		if selectedDealDetail.images.count > 0 {
			var urlArray = [URL]()
		
			for i in 0..<selectedDealDetail.images.count {
			
				let imageString = Constant.WebServicesApi.baseUrl + selectedDealDetail.images[i].image
				let imageUrl = URL(string:imageString)
				urlArray.append(imageUrl!)
			}
			
			var photos = [SSPhoto]()
			
			let photosWithURL = SSPhoto.photosWithURLs(urlArray)
			
			photos += photosWithURL
			let indexPath:NSIndexPath = IndexPath.init(row: scrollViewImage.currentPage, section: 0) as NSIndexPath
			
			showBrowser(photos: photos, indexPath: indexPath as NSIndexPath)
		}
	}
	
	private func showBrowser (photos: [SSPhoto], indexPath: NSIndexPath) {
		// Create and setup browser
		let browser = SSImageBrowser(aPhotos: photos, animatedFromView: nil)
		browser.displayActionButton = false
		browser.displayDownloadButton = false
		browser.setInitialPageIndex(indexPath.row)
		browser.delegate = self as? SSImageBrowserDelegate
		
		// Show
		present(browser, animated: true, completion: nil)
	}
	
	func loadDidLoadData() {
		
		var localTimeZoneName: String { return TimeZone.current.identifier }
		localTimeZone = localTimeZoneName
		viewAllForOptionButton.setTitle("View All Options for \(selectedDealDetail.business.name!)", for: .normal)
		btnVerifyCount.setTitle(String(selectedDealDetail.vrified), for: .normal)
		self.lblCreatedName.text = selectedDealDetail.objAddedBy.name
		self.lblTimePassedForDaysAgo.text = selectedDealDetail.objAddedBy.time
		self.lblLastVerifiedName.text = selectedDealDetail.lastVerifiedBy.name
		self.lblTimePassLastVerified.text = selectedDealDetail.lastVerifiedBy.time
		//self.lblPizzaOrderName.text = selectedDealDetail.title
        let trimmedString = selectedDealDetail.title.utf8DecodedString().replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
        self.lblPizzaOrderName.text = trimmedString
		self.callForScrollView()
		self.initialiseForView()
		self.scrollViewImage.delegate = self
		lblPaging.createCornerRadiusForLabel()
		if selectedDealDetail.images.count < 1 {
			lblPaging.isHidden = true
		}
		lblPaging.text = "\(1)" + " of " + "\(selectedDealDetail.images.count)" + " >"
	}
	
	@objc func methodOfReceivedNotification(notification: Notification) {
		getDealDetails(dealId: selectedDealDetail.dealId)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//UIApplication.shared.isStatusBarHidden = true
		loadWillAppearData()
	}
	
	func loadWillAppearData() {
		checkLocationIsEnable()
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showUserDetailIdentifier"{
			let otherProfileObj = segue.destination as! OtherProfileVC
			otherProfileObj.otherUserData = otherProfileData
		}
	}
	
	// MARK: Scrollview for Images
	func callForScrollView () {
		self.automaticallyAdjustsScrollViewInsets = false
		scrollViewImage.frame = CGRect(x: CGFloat(0), y: 0, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.scrollViewImage.frame.height))
		let profileImages = UIImageView()
		if selectedDealDetail.images.count == 0{
			profileImages.frame = CGRect(x: CGFloat(0), y: scrollViewImage.frame.origin.y, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.layoutForScrollHeight.constant))
			profileImages.image = #imageLiteral(resourceName: "placeholder_Image")
			scrollViewImage.addSubview(profileImages)
		}else{
			for i in 0..<selectedDealDetail.images.count {
				let profileImages2 = UIImageView()
				profileImages2.frame = CGRect(x: CGFloat(self.scrollViewImage.frame.width * CGFloat(i)), y: scrollViewImage.frame.origin.y, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.layoutForScrollHeight.constant))
				profileImages2.contentMode = .scaleAspectFill
				profileImages2.clipsToBounds = true
				profileImages2.layer.masksToBounds = true
				let imageString = Constant.WebServicesApi.baseUrl + selectedDealDetail.images[i].image
				let imageUrl = URL(string:imageString)
				profileImages2.kf.indicatorType = .activity
				profileImages2.kf.setImage(with: imageUrl)
				scrollViewImage.addSubview(profileImages2)
				UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {() -> Void in
					self.scrollViewImage.contentSize = CGSize(width: CGFloat(self.scrollViewImage.frame.width * CGFloat(i + 1)), height: CGFloat(self.layoutForScrollHeight.constant))
				}, completion: {(_ finished: Bool) -> Void in
				})
				scrollViewImage.showsHorizontalScrollIndicator = false
			}
		}
	}
	
	// MARK: Scrollview for Delegate
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let width = self.view.frame.size.width
		let page:Int = Int((scrollViewImage.contentOffset.x + width)/width)
		lblPaging.text = "\(page)" + " of " + "\(selectedDealDetail.images.count)" + " >"
	}
	
	func getOtherProfileDetails (userId:Int) {
		let params:NSDictionary = [
			"userId" : userId
		]
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getOtherProfileApi, params: params) { (responseObject) -> Void in
			do{
				self.otherProfileData = try JSONDecoder().decode(OtherProfileDetail.self, from:responseObject)
				self.performSegue(withIdentifier: "showUserDetailIdentifier", sender: self)
			}catch let jsonError{
				print("error",jsonError)
			}
		}
	}
	
	func initialiseForView () {
		buttonForVerification.tintColor = UIColor.clear
		if selectedDealDetail.verifiedByMe {
			buttonForVerification.isSelected = true
			imgLikeUnlike.image = #imageLiteral(resourceName: "unlike").maskWithColor(color: Constant.Color.k_AppNavigationColor)
		} else {
			buttonForVerification.isSelected = false
			imgLikeUnlike.image = #imageLiteral(resourceName: "unlike")
		}
		for btnDay in self.stackViewForDaysOfWeek.subviews {
			let btnDay = btnDay as! FooFuluButton
			for day in self.selectedDealDetail.days {
				if day.id == btnDay.tag {
					btnDay.backgroundColor = Constant.Color.k_AppNavigationColor
					btnDay.titleLabel?.textColor = UIColor.white
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	// MARK: - Button Action
	@IBAction func createdByButtonTapped(_ sender: Any) {
		if  super.guestUserOrNormal() {
			let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
				
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			
			present(alert, animated: true, completion: nil)        } else {
			guard let id = selectedDealDetail.objAddedBy.id else{
				super.alertViewController(title: "Alert!!", message: "Created by is none")
				return
			}
			getOtherProfileDetails(userId: id)
		}
	}
	
	@IBAction func lastVarifiedButtonTapped(_ sender: Any) {
		if  super.guestUserOrNormal() {
			let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
				
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			
			present(alert, animated: true, completion: nil)        } else {
			guard let id = selectedDealDetail.lastVerifiedBy.id else{
				super.alertViewController(title: "Alert!!", message: "Last Verified by is none")
				return
			}
			getOtherProfileDetails(userId: id)
		}
	}
	// MARK: - Button Action
	
	@IBAction func btnActForPopController(_ sender: Any) {
		if isComesFromLandingPage{
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
			appDelegate.window?.rootViewController = objMain
		}else{
			_ = navigationController?.popViewController(animated: true)
		}
	}
	
	@IBAction func buttonActForShare(_ sender: UIButton) {
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
			self.sharingOnSocialMedia()
		}
	}
	//////// Other class
	func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			completion(data, response, error)
			}.resume()
	}
	
	func sharingOnSocialMedia()   {
		var imageStringUrl:String = ""
		if selectedDealDetail.images.count > 0{
			imageStringUrl = Constant.WebServicesApi.baseUrl + selectedDealDetail.images[0].image
			let url = URL(string:imageStringUrl)
			getDataFromUrl(url: url!) { data, response, error in
				guard let data = data, error == nil else { return }
				DispatchQueue.main.async() {
					var imageShare = UIImage()
					imageShare = UIImage(data: data)! //check
					self.createLink(imageShare: imageShare)
				}
			}
		}else{
			let imageShare = UIImage()
			self.createLink(imageShare: imageShare)
		}
	}
	
	func createLink(imageShare: UIImage) {
		let buo = BranchUniversalObject.init()
		buo.title = "Foofulu"
		buo.contentMetadata.customMetadata["dealId"] = selectedDealDetail.dealId
		let linkProperties = BranchLinkProperties.init()
		linkProperties.channel = "Foofulu"
		buo.getShortUrl(with: linkProperties) { (urlString: String?, error: Error?) in
			if let s = urlString {
				let branchURL:URL?
				branchURL = URL.init(string: s)
				self.callActivity(linkToShare:branchURL!,image:imageShare)
			} else {
			}
		}
	}

	func callActivity(linkToShare:URL,image:UIImage) {
		let objectsToShare = [linkToShare,image] as [Any]
		let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
		self.present(activityViewController, animated: true, completion: nil)
		activityViewController.completionHandler = {(activityType, completed:Bool) in
			if completed {
				print("task alert completed")
				return
			} else {
				print("task alert not completed")
				return
			}
		}
	}
	
	@IBAction func btnActForDelete(_ sender: UIButton) {
		if  super.guestUserOrNormal() {
			let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
				
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			
			present(alert, animated: true, completion: nil)        } else {
			self.funCallBtnActForDelete()
		}
	}
	
	func funCallBtnActForDelete () {
		let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this deal?", preferredStyle: .alert)
		let yesButton = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
			self.disableDealDeleteApi()
			alert.dismiss(animated: true, completion: { _ in })
		})
		let noButton = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
			alert.dismiss(animated: true, completion: { _ in })
		})
		alert.addAction(noButton)
		alert.addAction(yesButton)
		self.present(alert, animated: true, completion: { _ in })
	}
	
	func disableDealDeleteApi () {
		let params:NSDictionary = [
			"dealId" : selectedDealDetail.dealId
		]
		print(params)
		super.showAnloaderFunct (text:"Loading..")
		super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.disableDealApi, params: params) { (responseObject) -> Void in
			print(responseObject)
			self.navigationController?.popToRootViewController(animated: true)
		}
	}
	
	@IBAction func btnActForEdit(_ sender: UIButton) {
		if  super.guestUserOrNormal() {
			let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
				
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			
			present(alert, animated: true, completion: nil)        } else {
			// EditDealVC
			let objEditDealVC :EditDealVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDealVC") as! EditDealVC
			objEditDealVC.selectedDealDetailData = selectedDealDetail
			Constant.GlobalVariables.checkForDealEdit = "Data added"
			self.navigationController?.pushViewController(objEditDealVC, animated: true)
		}
	}
	
	@IBAction func buttonActForLikeUnlike(_ sender: UIButton) {
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
			let alert = UIAlertController(title: nil, message: "Are you sure you want to verify ?", preferredStyle: .alert)
			let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
				self.getAPIbuttonActForLikeUnlike()
				self.imgLikeUnlike.image = #imageLiteral(resourceName: "unlike").maskWithColor(color: Constant.Color.k_AppNavigationColor)
				sender.tintColor = .clear
				alert.dismiss(animated: true, completion: { _ in })
			})
			let noButton = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
				self.imgLikeUnlike.image = #imageLiteral(resourceName: "unlike")
				alert.dismiss(animated: true, completion: { _ in })
			})
			alert.addAction(noButton)
			alert.addAction(yesButton)
			self.present(alert, animated: true, completion: { _ in })
		}
	}
	
	func getAPIbuttonActForLikeUnlike () {
		let params:NSDictionary = [
			"dealId" : selectedDealDetail.dealId
		]
		super.showAnloaderFunct (text:"Loading..")
		super.postMultipleArrayServiceWithParameters(requestUrl:Constant.WebServicesApi.apiVerifyDeal, params: params) {(responseObject) -> Void in
			print(responseObject)
			let varifiedCount = responseObject["vrified"]!
			let lastVarifiedName = (responseObject as! NSDictionary).value(forKeyPath: "lastVerifiedBy.name")
			let lastVarifiedAgo = (responseObject as! NSDictionary).value(forKeyPath: "lastVerifiedBy.time")
			
			self.btnVerifyCount.setTitle(String(describing: varifiedCount!), for: .normal)
			self.lblLastVerifiedName.text = lastVarifiedName as? String
			self.lblTimePassLastVerified.text = lastVarifiedAgo as? String
		}
	}
	
	@IBAction func actionViewAllOptions(_ sender: Any) {
		
		getBusinessDetails(businessId:selectedDealDetail.business.id)
	}
	
	fileprivate func checkLocationIsEnable(){
		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined, .restricted, .denied:
				if #available(iOS 10.0, *) {
					let alertController = UIAlertController (title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: .alert)
					let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
						CommonUtilities.openSettings()
					}
					alertController.addAction(settingsAction)
					let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
					alertController.addAction(cancelAction)
					present(alertController, animated: true, completion: nil)
				}else{
					let alertController = UIAlertController (title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: .alert)
					let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
						CommonUtilities.openSettings()
					}
					alertController.addAction(settingsAction)
					let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
					alertController.addAction(cancelAction)
					present(alertController, animated: true, completion: nil)
				}
			case .authorizedAlways, .authorizedWhenInUse:
				locationManager.delegate = self
				locationManager.requestAlwaysAuthorization()
				locationManager.requestWhenInUseAuthorization()
				locationManager.startUpdatingLocation()
				locationManager.desiredAccuracy = kCLLocationAccuracyBest
				break
			}
		} else {
			AlertUtility.showAlert(self, title: nil, message: "Location services are not enabled", cancelButton: "Cancel", buttons: ["Settings"], actions: { (_, index) in
				if index != AlertUtility.CancelButtonIndex {
					CommonUtilities.openSettings()
				}
			})
		}
	}
	
	//MARK:- CLLOCATION DELEGATE(S)
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
        if manager.location != nil {
            let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
            latitude = currentLocation.latitude
            longitude = currentLocation.longitude
        }
	}
	
	func getBusinessDetails (businessId:Int) {
		let params:NSDictionary = [
			"bussinessId" : businessId,
			"latitude" : latitude,
			"longitude" : longitude,
			"day":"1",
			"timeZone":localTimeZone ?? "i"

		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getBussinessDetails, params: params) { (responseObject) -> Void in
			print(responseObject)
			do{
				let objHomeDayDetailEditVC :HomeDayDetailEditVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDayDetailEditVC") as! HomeDayDetailEditVC
				objHomeDayDetailEditVC.passBusinessData = try JSONDecoder().decode(Business.self, from:responseObject)
				self.navigationController?.pushViewController(objHomeDayDetailEditVC, animated: true)
			}catch let jsonError{
				print("error",jsonError)
			}
		}
	}
	
	func getDealDetails (dealId:Int) {
		let params:NSDictionary = [
			"dealId" : dealId
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getDealDetails, params: params) { (responseObject) -> Void in
			print(responseObject)
			do{
				self.selectedDealDetail = try JSONDecoder().decode(DealDetail.self, from:responseObject)
				
				self.loadDidLoadData()
				self.loadWillAppearData()
				
			} catch let jsonError{
				print("error",jsonError)
			}
		}
	}
}
