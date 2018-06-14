//
//  AddDealVC.swift
//  FooFulu
//
//  Created by netset on 11/6/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation

class AddDealVC: BaseVC,CLLocationManagerDelegate {
	//MARK:- OUTLET(S)
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var addDealTableView: UITableView!
	//MARK:- CONSTANT(S)
	struct Identifier {
		enum Cell:String {
			case AddDealTableViewCell
		}
		enum Segue:String {
			case addDealDetail
		}
	}
	var locationManager = CLLocationManager()
	var latitude:Double! = nil
	var longitude:Double! = nil
	var businessArray = BusinessData()
	var textForSearch:String = " "
	var busienessDetail:BusinessDetail!
	var sortedArray = [BusinessDetail]()
	
	//MARK:- LIFE CYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.tintColor = UIColor.white
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
		textFieldInsideSearchBar?.layer.cornerRadius = 0
		textFieldInsideSearchBar?.clipsToBounds = true
		self.automaticallyAdjustsScrollViewInsets = false
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		self.tabBarController?.navigationItem.titleView=nil
		self.tabBarController?.navigationItem.title = "Add deal"
		self.tabBarController?.navigationItem.rightBarButtonItem=nil
		checkLocationIsEnable()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Identifier.Segue.addDealDetail.rawValue{
			let addDealType = segue.destination as! AddTypeDealVC
			addDealType.selectedbusienessDetail = busienessDetail
		}
	}
	//MARK:- PRIVATE METHOD(S)
	fileprivate func getVenueList(searchText:String,latitude:Double,Longitude:Double) {
		let parameters = ["client_id":"djMN5foS-I7IkHL2WxWE2Q",
						  "client_secret":"PgaojXN5XD1D2qCFAcJasG40G4K1lR5nQlYvu0Sk5u9u69aSkKDPzRVZb35tVuWp"]
		POSTYelpServiceWithParameters(params: parameters,searchText:searchText,latitude:latitude,longitude:longitude) { (result) in
			print(result)
			do{
				self.businessArray = try JSONDecoder().decode(BusinessData.self, from:result)
				self.sortedArray = self.businessArray.businesses
				self.searchBar.endEditing(true)
				self.addDealTableView.reloadData()
			}catch let jsonError{
				print("error",jsonError)
			}
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
	
	fileprivate func sortBusienessArray(searchText:String) {
        if businessArray.businesses != nil {
            sortedArray = businessArray.businesses.filter { ($0.name?.localizedCaseInsensitiveContains(searchText))! }
            addDealTableView.reloadData()
        }
	}
	
	//MARK:- CLLOCATION DELEGATE(S)
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
        if manager.location != nil {
            let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
            latitude = currentLocation.latitude
            longitude = currentLocation.longitude
            getVenueList(searchText: "", latitude: latitude, Longitude: longitude)
            locationManager.stopUpdatingLocation()
        }
	}
	
	//MARK:- SEARCH BAR DELEGATE(S)
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if latitude != nil && longitude != nil {
            getVenueList(searchText: textForSearch, latitude: latitude, Longitude: longitude)
        }
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		sortBusienessArray(searchText: searchText)
		if searchText.isEmpty{
            if latitude != nil && longitude != nil {
                getVenueList(searchText: textForSearch, latitude: latitude, Longitude: longitude)
            }
		}
		textForSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
//MARK:- UITABLEVIEW DATASOURCE(S) AND DELEGATE(S)
extension AddDealVC:UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sortedArray.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = Constant.Color.k_AppSectionColor
		let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width:
			tableView.bounds.size.width, height: tableView.bounds.size.height))
		headerLabel.font = UIFont(name: "Regular", size: 14.0)
		headerLabel.textColor = UIColor.darkGray
		headerLabel.text = "Nearby Businesses"
		headerLabel.sizeToFit()
		headerView.addSubview(headerLabel)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.Cell.AddDealTableViewCell.rawValue, for: indexPath) as! AddDealTableViewCell
		let busienessData = sortedArray[indexPath.row]
		cell.hotelName.text = busienessData.name
		//cell.address.text = "\(String(describing: busienessData.location?.address1))\(String(describing: busienessData.location?.country))"
        cell.address.text = (busienessData.location?.address1)! + " " +  (busienessData.location?.country)!
        let milesValue = busienessData.distance! / 1609.344
		let formattedDistance = "\(String(format: "%.2f", milesValue))"
		cell.distance.text = "\(String(describing:formattedDistance)) mi"
		if busienessData.image_url != nil{
			let imageString = busienessData.image_url
			let imageUrl = URL(string:imageString!)
			cell.hotelImage.kf.indicatorType = .activity
			cell.hotelImage.kf.setImage(with: imageUrl)
		}
		cell.hotelImage.clipsToBounds=true
		cell.hotelImage.layer.cornerRadius=5.0
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < 0 {
			scrollView.contentOffset = CGPoint.zero
		}
		scrollView.isScrollEnabled = true
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
			busienessDetail = sortedArray[indexPath.row]
			performSegue(withIdentifier: Identifier.Segue.addDealDetail.rawValue, sender: nil)
		}
	}
}


extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
}
