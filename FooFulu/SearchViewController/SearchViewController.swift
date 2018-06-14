//
//  SearchViewController.swift
//  Foofulu
//
//  Created by netset on 21/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import LatLongToTimezone
//MARK:- CUSTOM DELEGATION
protocol SearchViewControllerDelegate {
	func passDealIdToLastViewController(dealId:Int)
	func passBussinessIDBack(bussinessId:Int,selectedLatitude:Double,selectedLongitude:Double)
	func passBussinessDetailsBack(bussinessDetail:BusinessDetail)
}

class SearchViewController: BaseVC,CLLocationManagerDelegate{
	//MARK:- OUTLET(S)
	@IBOutlet weak var noResultFoundLabel: UILabel!
	@IBOutlet weak var locationTextfield:UITextField!
	@IBOutlet weak var searchTableView:UITableView!
	@IBOutlet weak var searchTextfield:UITextField!
	
	//MARK:- CONSTNT(S)
	var busienessDetail:BusinessDetail!
	var currentWeekDay:Int?
	var businessData:Business!
	var selectedRowExpansion = NSMutableArray()
	var arrForHomeBussiness = NSArray()
	var delegate:SearchViewControllerDelegate!
	var locationManager = CLLocationManager()
	var askLocaionPermission = false
//	var localTimeZone:String?
	var dealDetail:DealDetail!
	var lat:Double = 0.0
	var long:Double = 0.0
	var latitude:Double! {
		get{
			return lat
		}set{
			lat = newValue
		}
	}
	var longitude:Double! {
		get{
			return long
		}set{
			long = newValue
		}
	}
	
	//MARK:- LIFE CYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		setleftViewImageOnTextfields()
		let date = Date()
		let calendar = Calendar.current
		currentWeekDay = calendar.component(.weekday, from: date)
	//	var localTimeZoneName: String { return TimeZone.current.identifier }
	//	localTimeZone = localTimeZoneName
		askLocaionPermission = true
		if askLocaionPermission{
			locationEnable()
			askLocaionPermission = false
		}else{
			checkLocationIsEnable()
		}
		self.searchTableView.tableFooterView = UIView()
	}
	
	//MARK:- OVVERRIDE METHOD
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
		searchTextfield.becomeFirstResponder()
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	//MARK:- FILEPRIVATE METHOD(S)
	fileprivate func setleftViewImageOnTextfields(){
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
		let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
		button.setImage(#imageLiteral(resourceName: "search_Icon"), for: .normal)
		button1.setImage(#imageLiteral(resourceName: "location_Icon"), for: .normal)
		searchTextfield.leftView = button
		searchTextfield.leftViewMode = .always
		locationTextfield.leftView = button1
		locationTextfield.leftViewMode = .always
	}
	
	fileprivate func locationEnable(){
		if (CLLocationManager.locationServicesEnabled()) {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		}
	}
	
	fileprivate func getDealDetails (dealId:Int) {
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
				self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
			} catch let jsonError{
				print("error",jsonError)
			}
		}
	}
	
	fileprivate func navigateToBusienessDetail(bussinessDetail:BusinessDetail){
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
	
	fileprivate func getBusinessDetails (businessId:Int) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let timeZone = TimezoneMapper.latLngToTimezone(location)
        print(timeZone ?? "i")
		let params:NSDictionary = [
			"bussinessId" : businessId,
			"latitude" : latitude,
			"longitude" : longitude,
			"day":currentWeekDay ?? "",
            "timeZone":timeZone!.identifier
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
	
	fileprivate func getDealsList(searchText:String){
		let params:NSDictionary = [
			"text" : searchText,
//			"latitude":40.71334,
//			"longitude":-74.0081
			"latitude":latitude,
			"longitude":longitude
		]
		postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.searchDeals, params: params) {(response) -> Void in
				self.arrForHomeBussiness = response.value(forKey: "deals") as! NSArray
//				self.dealDetail = try [JSONDecoder().decode(DealData.self, from:response)]
				self.showHideNoDataFoundLabel()
				self.view.endEditing(true)
				self.searchTableView.reloadData()
		}
	}
	
	fileprivate func checkLocationIsEnable() {
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
				} else {
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
	
	fileprivate func showHideNoDataFoundLabel(){
		if self.arrForHomeBussiness.count == 0{
			self.noResultFoundLabel.isHidden = false
		}else{
			self.noResultFoundLabel.isHidden = true
		}
	}
	
	//MARK:- IB-ACTION(S)
	@IBAction func userCurrentLocationButtonTapped(_ sender: Any) {
		checkLocationIsEnable()
	}
	
	@IBAction func cancelButtonTapped(_ sender: Any) {
//		self.dismiss(animated: true, completion: nil)
		let transition = CATransition()
		transition.duration = 0.5
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromBottom
		self.navigationController?.view.layer.add(transition, forKey: nil)
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func searchButtonTapped(_ sender: Any) {
		getDealsList(searchText: searchTextfield.text!)
	}
	
	//MARK:- CLLOCATION DELEGATE(S)
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
		let currentLocation = locations.first
		latitude = currentLocation!.coordinate.latitude
		longitude = currentLocation!.coordinate.longitude
		let location = CLLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
		convertCoordinatesToLocationName(location: location)
	}
	
	fileprivate func convertCoordinatesToLocationName(location:CLLocation){
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location, completionHandler: {
			placemarks, error in
			if let err = error {
				print( err.localizedDescription)
			} else if let placemarkArray = placemarks {
				if let placemark = placemarkArray.first {
					if let city = placemark.locality {
						self.locationTextfield.text = city
					}
				} else {
					print( "Placemark was nil")
				}
			} else {
				print( "Unknown error")
			}
		})
	}
}
//MARK:- GMSAUTOCOMPLETEVIEWCONTROLLER  DELEGATE(S)
extension SearchViewController:GMSAutocompleteViewControllerDelegate{
	func presentGoogleAutoCompleteViewController() {
		let acController = GMSAutocompleteViewController ()
		acController.delegate = self
		UISearchBar.appearance().barStyle = UIBarStyle.default
		self.present(acController, animated: true, completion: nil)
	}
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		dismiss(animated: true, completion: nil)
		locationTextfield.text = place.name
		latitude = place.coordinate.latitude
		longitude = place.coordinate.longitude
		print("NAme = ", place.name)
	}
	public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		print("View controller is cancelled")
		dismiss(animated: true, completion: nil)
	}
	public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
		print("error occured is \(error)")
	}
}
//MARK:- UITEXTFIELD  DELEGATE(S)
extension SearchViewController:UITextFieldDelegate{
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == locationTextfield{
			presentGoogleAutoCompleteViewController()
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
//MARK:- UITABLEVIEW DATASOURCE(S) AND DELEGATE(S)
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if arrForHomeBussiness.count > 0 {
			return arrForHomeBussiness.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if arrForHomeBussiness.count > 0 {
			let array = (arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray
			if array.count > 0 {
				if ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray).count>2{
					if !selectedRowExpansion.contains(section){
						return 3
					}else{
						return ((self.arrForHomeBussiness.value(forKey: "deals") as! NSArray).object(at: section) as! NSArray).count+1
					}
				}
				return array.count
			}
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath)
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
                let string : String = (((self.arrForHomeBussiness.value(forKeyPath: "deals.title") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as? String)!.utf8DecodedString()
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
                    let string : String = (((self.arrForHomeBussiness.value(forKeyPath: "deals.title") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as? String)!.utf8DecodedString()
                    let trimmedString = string.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                    lablOrder.text = trimmedString
				}
			}
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath)
		let lablOrder = cell?.viewWithTag(1) as! UILabel
		if lablOrder.text! == generalStrings.viewAllOptions.rawValue || lablOrder.text! == generalStrings.ViewLess.rawValue {
			if selectedRowExpansion.contains(indexPath.section) {
				selectedRowExpansion.remove(indexPath.section)
			} else {
				selectedRowExpansion.add(indexPath.section)
			}
			UIView.transition(with: tableView,
							  duration: 0.35,
							  options: .transitionCrossDissolve,
							  animations: { tableView.reloadData() })
		} else {
			self.dismiss(animated: true, completion: nil)
//			delegate.passDealIdToLastViewController(dealId: (((self.arrForHomeBussiness.value(forKeyPath: "deals.id") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! Int))
			self.getDealDetails(dealId: (((self.arrForHomeBussiness.value(forKeyPath: "deals.id") as! NSArray).object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! Int))
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		//return UIView()
		if (arrForHomeBussiness.value(forKey: "hasDeals") as! NSArray).object(at: section) as! Bool == true {
			let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
			let imgRestaurant = defaultCell.viewWithTag(1) as! UIImageView
			imgRestaurant.cornerRadiusForView()
			let lblForTitle = defaultCell.viewWithTag(2) as! UILabel
			let setRatingView = defaultCell.viewWithTag(3) as! FloatRatingView
			let lblREveCount = defaultCell.viewWithTag(4) as! UILabel
			let lblRestTypes = defaultCell.viewWithTag(5) as! UILabel
			let lblDistance = defaultCell.viewWithTag(7) as! UILabel
			let lblPrice = defaultCell.viewWithTag(8) as! UILabel
			let lblForRestaurantAddress = defaultCell.viewWithTag(6) as! UILabel
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
			lblPrice.text = (arrForHomeBussiness.value(forKey: "price") as! NSArray).object(at: section) as? String
            lblREveCount.text = "\((arrForHomeBussiness.value(forKey: "review_count") as! NSArray).object(at: section))" + " reviews"
			if ((arrForHomeBussiness.value(forKey: "photo") as? NSArray)?.object(at: section)  as! String).count > 0{
				let imageString = (arrForHomeBussiness.value(forKey: "photo") as? NSArray)?.object(at: section) as! String
				let imageUrl = URL(string:imageString)
				imgRestaurant.kf.indicatorType = .activity
				imgRestaurant.kf.setImage(with: imageUrl)
			}
			super.ratingColorCordination(setRatingView: setRatingView)
			defaultCell.isUserInteractionEnabled = true
			let button = UIButton()
			button.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: (defaultCell.bounds.size.height))
			button.backgroundColor = .clear
			button.tag = section+1
			button.addTarget(self, action: #selector(handleTap(sender:)), for: .touchUpInside)
			defaultCell.addSubview(button)
			return defaultCell
		}
		else {
			let defaultCell = tableView.dequeueReusableCell(withIdentifier: "AddDealTableViewCell") as! AddDealTableViewCell
			defaultCell.hotelName.text = (arrForHomeBussiness.value(forKey: "name") as? NSArray)?.object(at: section) as? String
			defaultCell.address.text = (arrForHomeBussiness.value(forKey: "location") as? NSArray)?.object(at: section) as? String
			let milesValue = ((arrForHomeBussiness.value(forKey: "distance") as? NSArray)?.object(at: section) as? Double)! / 1609.344
			let formattedDistance = "\(String(format: "%.2f", milesValue))"
			defaultCell.distance.text = "\(String(describing:formattedDistance)) mi"
			if ((arrForHomeBussiness.value(forKey: "photo") as? NSArray)?.object(at: section)  as! String).count > 0{
				let imageString = (arrForHomeBussiness.value(forKey: "photo") as? NSArray)?.object(at: section) as! String
				let imageUrl = URL(string:imageString)
				defaultCell.hotelImage.kf.indicatorType = .activity
				defaultCell.hotelImage.kf.setImage(with: imageUrl)
			}
			defaultCell.hotelImage.clipsToBounds=true
			defaultCell.hotelImage.layer.cornerRadius=5.0
			let button = UIButton()
			button.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: (defaultCell.bounds.size.height))
			button.backgroundColor = .clear
			button.tag = section+1
			button.addTarget(self, action: #selector(handleTap1(sender:)), for: .touchUpInside)
			defaultCell.addSubview(button)
			return defaultCell
		}
	}
	
	func handleTap (sender:UIButton) {
		self.dismiss(animated: true, completion: nil)
		getBusinessDetails(businessId:(self.arrForHomeBussiness.value(forKey: "bussinessId") as! NSArray).object(at: sender.tag-1) as! Int)

//		let array = self.arrForHomeBussiness.value(forKey: "bussinessId") as! NSArray
//		let _:Int = array[sender.tag-1] as! Int
//		delegate.passBussinessIDBack(bussinessId: (self.arrForHomeBussiness.value(forKey: "bussinessId") as! NSArray).object(at: sender.tag-1) as! Int,selectedLatitude:latitude,selectedLongitude:longitude)
	}
	
	func handleTap1 (sender:UIButton) {
		self.dismiss(animated: true, completion: nil)
		let data = arrForHomeBussiness[sender.tag - 1] as! NSDictionary
		let dataBusiness = BusinessDetail()
		let location = dataBusiness.location
		location?.address1 = data.object(forKey: "location") as? String
		dataBusiness.id = data.object(forKey: "bussinessId") as? String
		dataBusiness.name = data.object(forKey: "name") as? String
		dataBusiness.image_url = data.object(forKey: "photo") as? String
		dataBusiness.is_closed = data.object(forKey: "is_closed") as? Bool
		dataBusiness.url = data.object(forKey: "bussinessId") as? String
		dataBusiness.review_count = Int((data.object(forKey: "review_count") as! String))
		dataBusiness.rating = data.object(forKey: "rating") as? Double
		dataBusiness.price = data.object(forKey: "price") as? String
		dataBusiness.phone = data.object(forKey: "phone") as? String
		dataBusiness.display_phone = data.object(forKey: "phone") as? String
		dataBusiness.distance = data.object(forKey: "distance") as? Double
		dataBusiness.location = location
//		delegate.passBussinessDetailsBack(bussinessDetail: dataBusiness)
		navigateToBusienessDetail(bussinessDetail: dataBusiness)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if (arrForHomeBussiness.value(forKey: "hasDeals") as! NSArray).object(at: section) as! Bool == true {
			return 98
		}else {
			return 80
		}
	}
}

