//
//  HomeVC.swift
//  FooFulu
//
//  Created by netset on 11/8/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import CoreLocation


enum generalStrings: String {
	case viewAllOptions = "View All Options"
	case ViewLess = "View Less"
	case guestSecretKey = "foofulusakjjb1df5dcvfds6cvxb"
	case message = "You need to sign up in order to proceed"
}

class HomeVC: BaseVC,UITableViewDelegate,UITableViewDataSource ,CLLocationManagerDelegate, UITextFieldDelegate,SearchViewControllerDelegate,UIScrollViewDelegate{
	
	struct Identifier {
		enum Cell:String {
			case AddDealTableViewCell
		}
		enum Segue:String {
			case addDealDetail
		}
	}
	
	@IBOutlet var objSearchBar: UISearchBar!
	@IBOutlet weak var btnForFoodType: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var btnForDistance: UIButton!
	@IBOutlet weak var btnForFaovrite: UIButton!
	@IBOutlet weak var btnForOpenNow: UIButton!
	@IBOutlet weak var btnForDays: UIButton!
	@IBOutlet weak var blackView: UIView!
	@IBOutlet weak var filterTableView: UITableView!
	@IBOutlet weak var layoutBottomFilterAxis: NSLayoutConstraint!
	@IBOutlet weak var lblHeader: UILabel!
	@IBOutlet weak var layoutHeightForFilterTableView: NSLayoutConstraint!
	@IBOutlet weak var lblResultsFound: UILabel!
	var askLocaionPermission = false
	var isComingFromSearch = false
	var localTimeZone:String?
	var businessDetail:BusinessDetail!
	var businessData:Business!
	var latitude:Double! = nil
	var longitude:Double! = nil
	var locationManager = CLLocationManager()
	var dealDetail:DealDetail!
	var strForFoodType:String?
	var strForDistance:String?
	var strForOpen:String?
	var strForDays:String?
	var strLblHeaderName:String!
	var btnTag = [UIButton]()
	var arrFoodTypeSet = NSArray()
	var arrFoodTypeValue = NSArray()
	var selectedIndex = Int()
	var selectedRowExpansion = NSMutableArray()
	var topSelected : Int = 0
	var btnTaggg : Int = 0
	var arrForHomeBussiness = NSArray()
	var foodData = NSDictionary()
	var currentWeekDay:Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let date = Date()
		let calendar = Calendar.current
		currentWeekDay = calendar.component(.weekday, from: date)
		var localTimeZoneName: String { return TimeZone.current.identifier }
		localTimeZone = localTimeZoneName
		askLocaionPermission = true
		btnForDays .setTitle(currentDay(), for: .normal)  //.text = currentDay()
		blackView.isUserInteractionEnabled = true
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
		blackView.addGestureRecognizer(tapGesture)
		btnForFoodType.backgroundColor = UIColor.clear
		Constant.GlobalVariables.checkForSearchBar = "ShowSearch"
		selectedIndex = 0
		//        filterTableView.frame = CGRect.init(x: filterTableView.frame.origin.x, y: filterTableView.frame.origin.y, width: self.view.frame.size.width, height: self.layoutHeightForFilterTableView.constant)
		let rectShape = CAShapeLayer()
		rectShape.bounds = self.filterTableView.frame
		rectShape.position = self.filterTableView.center
		rectShape.path = UIBezierPath(roundedRect: self.filterTableView.bounds, byRoundingCorners:[.topRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
		self.filterTableView.layer.backgroundColor = UIColor.green.cgColor
		//Here I'm masking the textView's layer with rectShape layer
		self.filterTableView.layer.mask = rectShape
		if let catStr = UserDefaults.standard.value(forKey: "CategorySelected") as? String {
			strLblHeaderName = catStr
		} //else {
		// strLblHeaderName = "Category"
		// }
		self.setButnSender(sender: btnForFoodType, backgrndColor: .white, tintColor: .white, titleLblColor: .black, isSelected: false)
		filterToolbarShow(checkStatus: true)
		//   strForFoodType = "1"
		//   strForOpen = "1"
		foodData  = ["Category" : [["name":"Breakfast","id":"1"],
								   ["name":"Lunch","id":"2"],
								   ["name":"Dinner","id":"3"],
								   ["name":"Happy Hour","id":"4"]],
					 "Distance" : [["name":"1 mile","id":"1"],
								   ["name":"2 miles","id":"2"],
								   ["name":"5 miles","id":"5"],
								   ["name":"10 miles","id":"10"],
								   ["name":"20 miles","id":"20"]] ,
					 "Open Now" : [["name":"On","id":"1"],
								   ["name":"Off","id":"2"]],
					 "Day of Week" : [["name":"Sunday","id":"1"],
									  ["name":"Monday","id":"2"],
									  ["name":"Tuesday","id":"3"],
									  ["name":"Wednesday","id":"4"],
									  ["name":"Thursday","id":"5"],
									  ["name":"Friday","id":"6"],
									  ["name":"Saturday","id":"7"]]]
		print(foodData)
		
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		isComingFromSearch = false
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	func getDayOfWeek() {//->Int {
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		let myComponents = myCalendar.components(.weekday, from: NSDate() as Date)
		let weekDay = myComponents.weekday
		topSelected = weekDay!-1
	}
	
	func getCategory() {//->Int {
		var str = String()
		let date = Date()
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: date)         // 1
		let minutes = calendar.component(.minute, from: date)    // 2
		let seconds = calendar.component(.second, from: date)    // 3
		print("\(hour):\(minutes):\(seconds)")                   // 4
		if hour<12 {
			str = "Breakfast"
		}  else if hour<17 {
			str = "Lunch"
		} else {
			str = "Dinner"
		}
		topSelected = arrFoodTypeSet.index(of: str)
	}
    
    
    func setOpenAndCloseTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)         // 1
        let minutes = calendar.component(.minute, from: date)    // 2
        let seconds = calendar.component(.second, from: date)    // 3
        print("\(hour):\(minutes):\(seconds)")                   // 4
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: NSDate() as Date)
        let weekDay = myComponents.weekday
        
        if hour >= 21 && weekDay != 1 {
            topSelected = 0
        } else if hour >= 18 && weekDay == 1 {
            topSelected = 0
        } else {
            topSelected = 1
        }
		
		
		
//		if weekDay != 1 {
//			if  hour < 21  {
//				topSelected = 1
//			}else{
//				topSelected = 0
//			}
//		} else if hour > 18 && weekDay == 1 {
//			topSelected = 0
//		} else {
//			topSelected = 1
//		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if askLocaionPermission{
			locationEnable()
			askLocaionPermission = false
		}else{
			checkLocationIsEnable()
		}
		if let dealId = UserDefaults.standard.value(forKey: "dealId"){
			getDealDetails(dealId: dealId as! Int)
		}else if let busienessId = UserDefaults.standard.value(forKey: "bussinessId"){
			let when = DispatchTime.now() + 3
			DispatchQueue.main.asyncAfter(deadline: when) {
				self.getBusinessDetails(businessId: busienessId as! Int)
			}
		}
		self.view.backgroundColor = Constant.Color.k_AppNavigationColor
		self.tabBarController?.navigationItem.title = nil
		self.tabBarController?.navigationItem.titleView = objSearchBar
		self.automaticallyAdjustsScrollViewInsets = false
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		if strForFoodType?.count==0 || strForFoodType==nil || strLblHeaderName != nil{
			topSelected = 0
			arrFoodTypeSet = (foodData.value(forKeyPath: "Category.name")! as! NSArray)
			arrFoodTypeValue = (foodData.value(forKeyPath: "Category.id")! as! NSArray)
			if strLblHeaderName == nil{
				getCategory()
			} else {
				topSelected = arrFoodTypeSet.index(of: strLblHeaderName)
				UserDefaults.standard.removeObject(forKey: "CategorySelected")
				strLblHeaderName=nil
			}
			strForFoodType = (arrFoodTypeValue[topSelected] as! String)
			self.setDataForFilters(btn:btnForFoodType)
			self.setButnSender(sender: btnForFoodType, backgrndColor: Constant.Color.k_AppNavigationColor, tintColor: Constant.Color.k_AppNavigationColor, titleLblColor: UIColor.white, isSelected: true)
		}
		if strForDistance?.count==0 || strForDistance==nil{
			topSelected = 2
			arrFoodTypeSet = (foodData.value(forKeyPath: "Distance.name")! as! NSArray)
			arrFoodTypeValue = (foodData.value(forKeyPath: "Distance.id")! as! NSArray)
			strForDistance = (arrFoodTypeValue[topSelected] as! String)
			self.setDataForFilters(btn:btnForDistance)
			self.setButnSender(sender: btnForDistance, backgrndColor: Constant.Color.k_AppNavigationColor, tintColor: Constant.Color.k_AppNavigationColor, titleLblColor: UIColor.white, isSelected: true)
		}
		if strForDays?.count==0 || strForDays==nil{
			topSelected = 0
			getDayOfWeek()
			arrFoodTypeSet = (foodData.value(forKeyPath: "Day of Week.name")! as! NSArray)
			arrFoodTypeValue = (foodData.value(forKeyPath: "Day of Week.id")! as! NSArray)
			strForDays = (arrFoodTypeValue[topSelected] as! String)
			self.setDataForFilters(btn:btnForDays)
			self.setButnSender(sender: btnForDays, backgrndColor: Constant.Color.k_AppNavigationColor, tintColor: Constant.Color.k_AppNavigationColor, titleLblColor: UIColor.white, isSelected: true)
		}
		if strForOpen?.count==0 || strForOpen==nil{
			topSelected = 0
			arrFoodTypeSet = (foodData.value(forKeyPath: "Open Now.name")! as! NSArray)
			arrFoodTypeValue = (foodData.value(forKeyPath: "Open Now.id")! as! NSArray)
            setOpenAndCloseTime()
			strForOpen = (arrFoodTypeValue[topSelected] as! String)
			self.setDataForFilters(btn:btnForOpenNow)
			self.setButnSender(sender: btnForOpenNow, backgrndColor: Constant.Color.k_AppNavigationColor, tintColor: Constant.Color.k_AppNavigationColor, titleLblColor: UIColor.white, isSelected: true)
		}
		//		self.getApiForBussiness(open: strForOpen!, distance: strForDistance!, day: strForDays!, meal: strForFoodType!)
	}
	
	func locationEnable(){
		if (CLLocationManager.locationServicesEnabled()) {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "searchScreenIdentifier"{
//			let searchObj = segue.destination as! SearchViewController
//			searchObj.delegate = self
//		}
//		if segue.identifier == Identifier.Segue.addDealDetail.rawValue{
//			let addDealType = segue.destination as! AddTypeDealVC
//			addDealType.selectedbusienessDetail = businessDetail
//		}
	}
	
	func passDealIdToLastViewController(dealId:Int) {
		getDealDetails(dealId: dealId)
	}
	
	func passBussinessIDBack(bussinessId: Int, selectedLatitude: Double,selectedLongitude: Double) {
		getBusinessDetails(businessId: bussinessId)
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
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}
	}
	
	func getApiForBussiness (open:String, distance:String, day:String, meal:String,searchForText:String) {
		let params:NSDictionary = [
			"open" : open,
			"distance" : distance,
			"day" : day ,
			"meal" : meal,
            "latitude" : (latitude == nil) ? 0 : latitude ,
			"longitude" : (longitude == nil) ? 0 : longitude,
			"text": searchForText.trimmingCharacters(in: .whitespacesAndNewlines),
			"timeZone":localTimeZone ?? "i"
		]
		super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getBusinessList, params: params) { (responseObject) -> Void in
			self.arrForHomeBussiness = responseObject.value(forKey: "results") as! NSArray
			if self.arrForHomeBussiness.count == 1 {
				self.lblResultsFound.text = String(format:"%d result",self.arrForHomeBussiness.count)
			} else {
				self.lblResultsFound.text = String(format:"%d results",self.arrForHomeBussiness.count)
			}
			self.tableView.reloadData()
		}
	}
	
	func tapBlurButton(_ sender: UITapGestureRecognizer) {
		if btnTaggg == 11 {
			self.setButtonTitle(btn: btnForFoodType)
		} else if btnTaggg == 12 {
			self.setButtonTitle(btn: btnForDistance)
		} else if btnTaggg == 13 {
			self.setButtonTitle(btn: btnForOpenNow)
		}else if btnTaggg == 14 {
			self.setButtonTitle(btn: btnForDays)
		}
		self.filterToolbarShow(checkStatus: true)
	}
	
	func setButtonTitle(btn:UIButton)  {
		if btn.titleLabel?.textColor == .white {
			btn.backgroundColor = Constant.Color.k_AppNavigationColor
			btn.setTitleColor(.white, for: .normal)
		} else {
			btn.backgroundColor = .white
			btn.setTitleColor(.black, for: .normal)
		}
	}
	
	func attributedChangeColor (main_string:String, string_to_color:NSString) -> NSMutableAttributedString {
		let attribute = NSMutableAttributedString.init(string: main_string)
		let range = (main_string as NSString).range(of: string_to_color as String)
		attribute.addAttribute(NSForegroundColorAttributeName, value: Constant.Color.k_AppNavigationColor , range: range)
		return attribute
	}
	
	@IBAction func btnActForTopTabBar(_ sender: UIButton) {
		btnTaggg = sender.tag
		filterTableView.backgroundColor = UIColor.clear
		selectedIndex = 0
		self.filterByCategory(sender: sender)
	}
	
	func setButnSender(sender:UIButton, backgrndColor:UIColor, tintColor:UIColor, titleLblColor:UIColor,isSelected:Bool) {
		sender.backgroundColor = backgrndColor
		sender.tintColor = tintColor
		sender.titleLabel?.textColor = titleLblColor
		sender.isSelected = isSelected
	}
	
	func filterByCategory(sender:UIButton) {
		sender.tintColor = .white
		sender.isSelected = true
		let sectionData : NSArray = foodData.allKeys as NSArray
		lblHeader.text = (sectionData.object(at: sender.tag-11) as? String)
		arrFoodTypeSet = (foodData.value(forKeyPath: lblHeader.text! + ".name")! as! NSArray)
		arrFoodTypeValue = (foodData.value(forKeyPath: lblHeader.text! + ".id")! as! NSArray)
		if sender.isSelected {
			self.setButnSender(sender: sender, backgrndColor: Constant.Color.k_AppNavigationColor, tintColor: Constant.Color.k_AppNavigationColor, titleLblColor: UIColor.white, isSelected: false)
		} else {
			self.setButnSender(sender: sender, backgrndColor: UIColor.white, tintColor: UIColor.white, titleLblColor: UIColor.black, isSelected: true)
		}
		if sender.tag==11 {
			selectedIndex = arrFoodTypeValue.index(of: strForFoodType! )
		} else if sender.tag==12 {
			selectedIndex = arrFoodTypeValue.index(of: strForDistance!)
		} else if sender.tag==13 {
			selectedIndex = arrFoodTypeValue.index(of: strForOpen!)
		} else if sender.tag==14 {
			selectedIndex = arrFoodTypeValue.index(of: strForDays!)
		}
		layoutBottomFilterAxis.constant = 0
		self.automaticallyAdjustsScrollViewInsets = false
		self.layoutHeightForFilterTableView.constant = CGFloat(34 * arrFoodTypeSet.count + 54)
		filterTableView.frame = CGRect.init(x: filterTableView.frame.origin.x, y: filterTableView.frame.origin.y, width: self.view.frame.size.width, height: self.layoutHeightForFilterTableView.constant)
		filterTableView.reloadData()
		self.filterToolbarShow(checkStatus: false)
		// self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	func currentDay() -> String{
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE"
		let result = formatter.string(from: date)
		return result
	}
	
	@IBAction func btnActForFilterDone(_ sender: Any) {
		if arrFoodTypeSet.count > 0 {
			if btnTaggg == 11 {
				self.setDataForFilters(btn:btnForFoodType)
				strForFoodType = (arrFoodTypeValue[topSelected] as! String)
			} else if btnTaggg == 12 {
				self.setDataForFilters(btn:btnForDistance)
				strForDistance = (arrFoodTypeValue[topSelected] as! String)
			} else if btnTaggg == 13 {
				self.setDataForFilters(btn:btnForOpenNow)
				strForOpen = (arrFoodTypeValue[topSelected] as! String)
			} else if btnTaggg == 14 {
				self.setDataForFilters(btn:btnForDays)
				strForDays = (arrFoodTypeValue[topSelected] as! String)
			}
			self.filterToolbarShow(checkStatus: true)
			print(arrFoodTypeValue[topSelected])
			self.getApiForBussiness(open: strForOpen!, distance: strForDistance!, day: strForDays!, meal: strForFoodType!, searchForText: "")
		}
	}
	
	func setDataForFilters(btn:UIButton)  {
		// var btnSetData : UIButton =  btn
		let attributedString = NSAttributedString(string: arrFoodTypeSet[topSelected] as! String + " " + "v")
		btn.titleLabel?.textColor = UIColor.white
		btn.setAttributedTitle(attributedString, for: .normal)
		//   btnSetData.titleLabel?.text = arrFoodTypeValue[topSelected]
	}
	
	func filterToolbarShow (checkStatus:Bool) {
		UIView.transition(with: self.view, duration: 0.6, options: .transitionCrossDissolve, animations: {() -> Void in
			self.blackView.isHidden = checkStatus
			self.filterTableView.isHidden = checkStatus
		}) { _ in }
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if tableView == filterTableView {
			return UIView()
		} else {
			//return UIView()
			let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
			let imgRestaurant = defaultCell?.viewWithTag(1) as! UIImageView
			imgRestaurant.cornerRadiusForView()
			let lblForTitle = defaultCell?.viewWithTag(2) as! UILabel
			let setRatingView = defaultCell?.viewWithTag(3) as! FloatRatingView
			let lblREveCount = defaultCell?.viewWithTag(4) as! UILabel
			let lblRestTypes = defaultCell?.viewWithTag(5) as! UILabel
			let lblDistance = defaultCell?.viewWithTag(7) as! UILabel
			let lblPrice = defaultCell?.viewWithTag(8) as! UILabel
			let lblForRestaurantAddress = defaultCell?.viewWithTag(6) as! UILabel
			setRatingView.isUserInteractionEnabled = false
			lblForRestaurantAddress.text = (arrForHomeBussiness.value(forKey: "location") as! NSArray).object(at: section) as? String
			var strcategories : String = ""
			for index in 0..<((arrForHomeBussiness.value(forKeyPath: "categories") as! NSArray).object(at: section) as! NSArray).count{
				if index == 0 {
					strcategories = ((arrForHomeBussiness.value(forKeyPath: "categories.title") as! NSArray).object(at: section) as! NSArray).object(at: index) as! String
				} else {
					strcategories = strcategories + " , " +  String(((arrForHomeBussiness.value(forKeyPath: "categories.title") as! NSArray).object(at: section) as! NSArray).object(at: index) as! String)
				}
				lblRestTypes.text = strcategories
			}
			// nil
			lblForTitle.text = (arrForHomeBussiness.value(forKey: "name") as! NSArray).object(at: section) as? String
			setRatingView.rating = ((arrForHomeBussiness.value(forKey: "rating") as! NSArray).object(at: section) as? Double)!
			let milesValue = (arrForHomeBussiness.value(forKey: "distance") as! NSArray).object(at: section) as! Double
			let formattedDistance = "\(String(format: "%.2f", milesValue))"
			lblDistance.text = "\(String(describing:formattedDistance)) mi"
			//   lblDistance.text = String(format:"%d",(arrForHomeBussiness.value(forKey: "distance") as! NSArray).object(at: section) as! CVarArg) + " mi"
			lblPrice.text = (arrForHomeBussiness.value(forKey: "price") as! NSArray).object(at: section) as? String
			//lblREveCount.text = String(format:"%d",(arrForHomeBussiness.value(forKey: "review_count") as! NSArray).object(at: section) as! CVarArg) + " reviews"
            
            lblREveCount.text = "\((arrForHomeBussiness.value(forKey: "review_count") as! NSArray).object(at: section))" + " reviews"
            if ((arrForHomeBussiness.value(forKey: "photos") as! NSArray).object(at: section) as! NSArray).count > 0 {
                let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                activityView.center = CGPoint(x: imgRestaurant
                    .bounds.size.width/2, y: imgRestaurant.bounds.size.height/2)
                activityView.color = UIColor.darkGray
                activityView.startAnimating()
                imgRestaurant.addSubview(activityView)
                let urlImage = ((arrForHomeBussiness.value(forKey: "photos") as! NSArray).object(at: section) as? NSArray)?.object(at: 0) as? String
                ImageLoader.sharedLoader.imageForUrl(urlString: urlImage!, completionHandler:{(image: UIImage?, url: String) in
                    imgRestaurant.image = image
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                })
            }
			super.ratingColorCordination(setRatingView: setRatingView)
			defaultCell?.isUserInteractionEnabled = true
			let button = UIButton()
			button.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: (defaultCell?.bounds.size.height)!)
			button.backgroundColor = .clear
			button.tag = section+1
			button.addTarget(self, action: #selector(handleTap(sender:)), for: .touchUpInside)
			defaultCell?.addSubview(button)
			return defaultCell
		}
		//return UIView()
	}
	
	func handleTap (sender:UIButton) {
		getBusinessDetails(businessId:(self.arrForHomeBussiness.value(forKey: "bussinessId") as! NSArray).object(at: sender.tag-1) as! Int)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func getBusinessDetails (businessId:Int) {
		let params:NSDictionary = [
			"bussinessId" : businessId,
			"latitude" : latitude,
			"longitude" : longitude,
			"day":currentWeekDay ?? "" ,
			"timeZone":localTimeZone ?? "i"
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getBussinessDetails, params: params) { (responseObject) -> Void in
			print(responseObject)
			do{
				self.businessData = try JSONDecoder().decode(Business.self, from:responseObject)
				let objHomeDayDetailEditVC :HomeDayDetailEditVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDayDetailEditVC") as! HomeDayDetailEditVC
				UserDefaults.standard.removeObject(forKey: "bussinessId")
				objHomeDayDetailEditVC.passBusinessData = self.businessData
				self.navigationController?.pushViewController(objHomeDayDetailEditVC, animated: true)
			} catch let jsonError {
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
				self.dealDetail = try JSONDecoder().decode(DealDetail.self, from:responseObject)
				let objEditHomeDealVC :EditHomeDealVC = self.storyboard?.instantiateViewController(withIdentifier: "EditHomeDealVC") as! EditHomeDealVC
				objEditHomeDealVC.selectedDealDetail = self.dealDetail
				UserDefaults.standard.removeObject(forKey: "dealId")
				self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
			} catch let jsonError{
				print("error",jsonError)
			}
		}
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
			AlertUtility.showAlert(self, title: nil, message:"Location services are not enabled", cancelButton: "Cancel", buttons: ["Settings"], actions: { (_, index) in
				if index != AlertUtility.CancelButtonIndex {
					CommonUtilities.openSettings()
				}
			})
		}
	}
	
	
	//MARK:- CLLOCATION DELEGATE(S)
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
        if manager.location != nil  {
            let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
            if !isComingFromSearch{
                latitude = currentLocation.latitude
                longitude = currentLocation.longitude
                self.getApiForBussiness(open: strForOpen!, distance: strForDistance!, day: strForDays!, meal: strForFoodType!, searchForText: "")
            }
        }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		print(indexPath.section)
		if tableView == filterTableView {
			topSelected = indexPath.row
			selectedIndex = indexPath.row
			filterTableView.reloadData()
		} else {
			let cell = tableView.cellForRow(at: indexPath)
			let lablOrder = cell?.viewWithTag(1) as! UILabel
			if lablOrder.text! == generalStrings.viewAllOptions.rawValue || lablOrder.text! == generalStrings.ViewLess.rawValue{
				if selectedRowExpansion.contains(indexPath.section){
					selectedRowExpansion.remove(indexPath.section)
				} else {
					selectedRowExpansion.add(indexPath.section)
				}
				UIView.transition(with: tableView,
								  duration: 0.35,
								  options: .transitionCrossDissolve,
								  animations: { self.tableView.reloadData() })
				
			} else {
				getDealDetails(dealId: (((self.arrForHomeBussiness.value(forKeyPath: "deals.id") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! Int))
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if tableView == filterTableView {
			return 0
		} else {
			return 104
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == filterTableView {
			return arrFoodTypeSet.count
		} else {
			if self.arrForHomeBussiness.count > 0 {
				if ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray).count>2{
					if !selectedRowExpansion.contains(section){
						return 3
					}else{
						return ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray).count+1
					}
				}
				return ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray).count
			}
		}
		return 0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if tableView == filterTableView {
			return 1
		} else {
			// return dict.count
			return self.arrForHomeBussiness.count
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if tableView == filterTableView {
			return 34
		} else {
			return 44
		}
	}
	
	/*  Create Cells  */
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		
		if tableView == filterTableView {
			cell = tableView.dequeueReusableCell(withIdentifier: "filterFooter", for: indexPath)
			cell.backgroundColor = UIColor.white
			let lblName = cell.viewWithTag(1) as! UILabel
			let btnRadio = cell.viewWithTag(2) as! UIButton
			if selectedIndex == indexPath.row {
				btnRadio.setImage(#imageLiteral(resourceName: "filterSelect"), for: .normal)
			} else {
				btnRadio.setImage(#imageLiteral(resourceName: "filterUnselect"), for: .normal)
			}
			btnRadio.addTarget(self, action: #selector(self.btnActForRadio(sender:)), for: .touchUpInside)
			lblName.text = (arrFoodTypeSet[indexPath.row] as! String)
			if indexPath.row == selectedIndex {
				btnRadio.isSelected = true
			} else {
				btnRadio.isSelected = false
			}
			return cell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath)
			let lablOrder = cell.viewWithTag(1) as! UILabel
			lablOrder.text = ""
			lablOrder.textAlignment = .left
			lablOrder.textColor = UIColor.black
			lablOrder.font = UIFont(name: "Arial", size: 12.0)
			if !selectedRowExpansion.contains(indexPath.section){
				if indexPath.row == 2 {
					lablOrder.text = generalStrings.viewAllOptions.rawValue
					lablOrder.textAlignment = .center
					lablOrder.textColor = Constant.Color.k_AppOrangeColor
					lablOrder.font=UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
				} else {
                    let string : String = ((((self.arrForHomeBussiness.value(forKeyPath: "deals.title") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as? String)?.utf8DecodedString())!
                    let trimmedString = string.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                    lablOrder.text = trimmedString
				}
			} else {
				if ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: indexPath.section) as! NSArray).count>2{
					if indexPath.row == ((self.arrForHomeBussiness.value(forKeyPath: "deals.title") as! NSArray).object(at: indexPath.section) as! NSArray).count{
						lablOrder.text = generalStrings.ViewLess.rawValue
						lablOrder.textAlignment = .center
						lablOrder.textColor = Constant.Color.k_AppOrangeColor
						lablOrder.font=UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
					}  else {
                        let string : String = ((((self.arrForHomeBussiness.value(forKeyPath: "deals.title") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as? String)?.utf8DecodedString())!
                        let trimmedString = string.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                        lablOrder.text = trimmedString
					}
				}
			}
		}
		return  cell
	}
	
	func btnActForRadio (sender:UIButton) {
		let buttonPosition = sender.convert(CGPoint.zero, to: self.filterTableView)
		let indexPath = self.filterTableView.indexPathForRow(at: buttonPosition)
		selectedIndex = (indexPath?.row)!
		topSelected = selectedIndex
		filterTableView.reloadData()
	}
}

extension HomeVC : UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty{
			self.getApiForBussiness(open: strForOpen!, distance: strForDistance!, day: strForDays!, meal: strForFoodType!, searchForText: "")
		}
		searchString = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//		performSegue(withIdentifier: "searchScreenIdentifier", sender: nil)
//		self.view.endEditing(true)
		objSearchBar.resignFirstResponder()
		let transition = CATransition()
		transition.duration = 0.5
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromTop
		self.navigationController!.view.layer.add(transition, forKey: nil)
		let writeView : SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
		self.navigationController?.pushViewController(writeView, animated: false)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		objSearchBar.resignFirstResponder()
		self.getApiForBussiness(open: strForOpen!, distance: strForDistance!, day: strForDays!, meal: strForFoodType!, searchForText: searchString)
	}
}

