//
//  OtherProfileVC.swift
//  FooFulu
//
//  Created by netset on 11/23/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import CoreLocation

class OtherProfileVC: BaseVC,CLLocationManagerDelegate{
    //MARK:- IB-OUTLET(S)
    @IBOutlet weak var navigationBackBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblFirstCharacName: UILabel!
    @IBOutlet weak var imgOtherUsers: UIImageView!
    //MARK:- CONSTANT(S)
    struct Identifiers {
        enum Cell:String {
            case OtherProfileBusinessTableViewCell
            case dealDetailCell
        }
        enum Storyboard:String {
            case HomeDayDetailEditVC
            case EditHomeDealVC
        }
    }
	var locationManager = CLLocationManager()
	var latitude:Double! = nil
	var longitude:Double! = nil
    var arrForOtherProfile = NSArray()
    var dicForInitialiseOtherProfile = NSDictionary()
    var otherUserData:OtherProfileDetail!
    var businessData:Business!
    var dealDetail:DealDetail!
	var localTimeZone:String?

    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
		var localTimeZoneName: String { return TimeZone.current.identifier }
		localTimeZone = localTimeZoneName
        viewInitialisation()
        navigationBackBtn.setImage(#imageLiteral(resourceName: "navigationBack").maskWithColor(color: UIColor.black), for: .normal)
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkLocationIsEnable()
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- IBACTION(S)
    @IBAction func btnActForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- PRIVATE METHOD(S)
    fileprivate func viewInitialisation () {
        lblName.text = otherUserData.user?.name
		lblFirstCharacName.text = otherUserData.user?.firstChar
        lblMemberSince.text = otherUserData.user?.memberSince
    }
    @objc fileprivate func headerCellTap(sender:UIButton){
        let selectedBusinessId = otherUserData.myDeals![sender.tag].businessId
        getBusinessDetails(businessId: selectedBusinessId!)
    }
	
	
    
    fileprivate func getBusinessDetails (businessId:Int) {
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
                self.businessData = try JSONDecoder().decode(Business.self, from:responseObject)
                let objHomeDayDetailEditVC :HomeDayDetailEditVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.Storyboard.HomeDayDetailEditVC.rawValue) as! HomeDayDetailEditVC
                objHomeDayDetailEditVC.passBusinessData = self.businessData
                self.navigationController?.pushViewController(objHomeDayDetailEditVC, animated: true)
            }catch let jsonError{
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
		let currentLocation:CLLocationCoordinate2D = manager.location!.coordinate
		latitude = currentLocation.latitude
		longitude = currentLocation.longitude
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
                let objEditHomeDealVC :EditHomeDealVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.Storyboard.EditHomeDealVC.rawValue) as! EditHomeDealVC
                objEditHomeDealVC.selectedDealDetail = self.dealDetail
                self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
            } catch let jsonError{
                print("error",jsonError)
            }
        }
    }
    
}
//MARK:- TABLEVIEW DELEGATE(S) AND DATASOURCE(S)
extension OtherProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (otherUserData.myDeals?.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let otherProfileHeaderCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.OtherProfileBusinessTableViewCell.rawValue) as! OtherProfileBusinessTableViewCell
        let headerData = otherUserData.myDeals![section]
        otherProfileHeaderCell.businessTitleLabel.text = headerData.businessName
        otherProfileHeaderCell.addressLabel.text = headerData.businesslocation
        otherProfileHeaderCell.ratingCountlabel.text = "\(String(describing: headerData.businessReviews!)) Reviews"
        otherProfileHeaderCell.businessRatingView.rating = headerData.businessRating!
        otherProfileHeaderCell.businessRatingView.isUserInteractionEnabled = false
        otherProfileHeaderCell.headerCellTapButton.tag = section
        otherProfileHeaderCell.headerCellTapButton.addTarget(self, action: #selector(headerCellTap), for: .touchUpInside)
        return otherProfileHeaderCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherUserData.myDeals![section].deals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.dealDetailCell.rawValue, for: indexPath)
        let dealsData = otherUserData.myDeals![indexPath.section]
        let lblCreatedByName = cell.viewWithTag(8) as! UILabel
        let lblDealTitle = cell.viewWithTag(10) as! UILabel
        let lblTime = cell.viewWithTag(11) as! UILabel
        let trimmedString = dealsData.deals![indexPath.row].dealTitle.utf8DecodedString().replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
        lblDealTitle.text = trimmedString
        lblTime.text = dealsData.deals![indexPath.row].time
        lblCreatedByName.text = dealsData.deals![indexPath.row].addedBy
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDealId = otherUserData.myDeals![indexPath.section]
        getDealDetails(dealId: selectedDealId.deals![indexPath.row].dealId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
