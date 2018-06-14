//
//  ProfileRestVC.swift
//  FooFulu
//
//  Created by netset on 11/6/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileRestVC: BaseVC,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate  {
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var layoutHeightForlbl: NSLayoutConstraint!
    @IBOutlet weak var imgNameFirstLetr: UILabel!
    @IBOutlet weak var btnMyDeals: FooFuluButton!
    @IBOutlet weak var btnMyFavourite: UIButton!
    @IBOutlet weak var lblFavouriteNumber: UILabel!
    var buttonTag = [UIButton]()
    var latitude:Double! = nil
    var longitude:Double! = nil
    var locationManager = CLLocationManager()
    var isNavigateToAnotherViewController:Bool = false
    var profileData = ProfileDetail()
    var businessData:Business!
    var dealDetail:DealDetail!
    var localTimeZone:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(CGPoint.zero, animated: true)
        
        var localTimeZoneName: String { return TimeZone.current.identifier }
        localTimeZone = localTimeZoneName
        buttonTag = [btnMyFavourite,btnMyDeals]
        imgNameFirstLetr.layer.cornerRadius = layoutHeightForlbl.constant/2
        imgNameFirstLetr.layer.masksToBounds = true
        imgUser.createCircleForImage()
        tableView.backgroundColor = Constant.Color.k_AppSectionColor
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(ProfileRestVC.tapImageButton(_:)))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(tapGestureImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        //.isHidden=true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationIsEnable()
        if !isNavigateToAnotherViewController{
            btnMyFavourite.isSelected = true
            btnMyDeals.isSelected = false
        }
        isNavigateToAnotherViewController = false
        if !(Constant.imageSet.originalImage == nil) {
            imgUser.image = Constant.imageSet.originalImage!
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // self.navigationController?.navigationItem.title = "My Profile"
        let buttonSetting = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(buttnActForSetting))
        self.navigationItem.rightBarButtonItem = buttonSetting
        if latitude != nil && longitude != nil {
            //            self.getApiForBussiness()
        }
    }
    
    func getApiForBussiness () {
        let params:NSDictionary = [
            "latitude" : latitude,
            "longitude" : longitude
        ]
        super.postDataMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.getProfileApi, params: params) { (responseObject) -> Void in
            do{
                self.profileData = try JSONDecoder().decode(ProfileDetail.self, from:responseObject)
                self.initialiseForProfile()
                self.showHideNoDataFoundLabel()
            }catch let jsonError{
                print("error",jsonError)
            }
            self.tableView.reloadData()
        }
    }
    
    
    fileprivate func checkLocationIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 10.0, *) {
                    let alertController = UIAlertController (title:"App Permission Denied", message:"To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle:.alert)
                    let settingsAction = UIAlertAction(title:"Settings", style:.default) { (_) -> Void in
                        CommonUtilities.openSettings()
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title:"Cancel", style:.default, handler: nil)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: .alert)
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
            self.getApiForBussiness()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func tapImageButton(_ sender: UITapGestureRecognizer) {
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
            super.openCameraSheet()
        }
    }
    
    func showHideNoDataFoundLabel(){
        if btnMyFavourite.isSelected{
            if profileData.bussinesses != nil {
                if profileData.bussinesses.count == 0 {
                    noDataFoundLabel.isHidden = false
                } else {
                    noDataFoundLabel.isHidden = true
                }
            }
        } else {
            if profileData.myDeals != nil {
                if profileData.myDeals.count == 0{
                    noDataFoundLabel.isHidden = false
                } else {
                    noDataFoundLabel.isHidden = true
                }
            }
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
                self.businessData = try JSONDecoder().decode(Business.self, from:responseObject)
                let objHomeDayDetailEditVC :HomeDayDetailEditVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDayDetailEditVC") as! HomeDayDetailEditVC
                objHomeDayDetailEditVC.passBusinessData = self.businessData
                self.isNavigateToAnotherViewController = true
                self.navigationController?.pushViewController(objHomeDayDetailEditVC, animated: true)
            } catch let jsonError{
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
                self.isNavigateToAnotherViewController = true
                self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
            } catch let jsonError{
                print("error",jsonError)
            }
        }
    }
    func headerCellTap(sender:UIButton){
        let selectedBusinessId = profileData.myDeals[sender.tag].businessId
        getBusinessDetails(businessId: selectedBusinessId!)
    }
    
    func initialiseForProfile () {
        lblUserName.text = profileData.user.name
        imgNameFirstLetr.text = profileData.user.firstChar
        if profileData.bussinesses.count == 1 {
            lblFavouriteNumber.text = "\(profileData.bussinesses.count)" + " " + "Favorite"
        } else {
            lblFavouriteNumber.text = "\(profileData.bussinesses.count)" + " " + "Favorites"
        }
    }
    
    func buttnActForSetting () {
        let objStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objSettingVC :SettingVC = objStoryboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.navigationController?.pushViewController(objSettingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if btnMyFavourite.isSelected {
            return UIView()
        }else {
            let profileHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ProfileRestTableViewCell") as! ProfileRestTableViewCell
            let headerData = profileData.myDeals[section]
            profileHeaderCell.businessTitle.text = headerData.businessName
            profileHeaderCell.dealNameLabel.text = headerData.businesslocation
            profileHeaderCell.ratingView.rating = headerData.businessRating
            profileHeaderCell.businessReviewsCountLabel.text = String(headerData.businessReviews!) + " reviews"
            profileHeaderCell.headerCellDidTapButton.tag = section
            profileHeaderCell.headerCellDidTapButton.addTarget(self, action: #selector(headerCellTap), for: .touchUpInside)
            return profileHeaderCell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if btnMyFavourite.isSelected {
            return 0
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !btnMyFavourite.isSelected {
            return 120
        } //else {
        // return 120
        //  }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if btnMyFavourite.isSelected {
            return 170
        } //else {
        return 150
        //}
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if btnMyFavourite.isSelected {
            return 1
        } else {
            if profileData.myDeals != nil{
                return profileData.myDeals.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnMyFavourite.isSelected {
            if profileData.bussinesses != nil{
                return profileData.bussinesses.count
            }else{
                return 0
            }
        } else {
            if profileData.myDeals != nil{
                return profileData.myDeals[section].deals!.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnMyFavourite.isSelected {
            let cellIdentifier = "cellFavourite"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let businessData = profileData.bussinesses[indexPath.row]
            let imgRestaurant = cell.viewWithTag(1) as! UIImageView
            imgRestaurant.cornerRadiusForView()
            if businessData.photos.count > 0 {
                let imageString = businessData.photos[0]
                let imageUrl = URL(string:imageString)
                imgRestaurant.kf.indicatorType = .activity
                imgRestaurant.kf.setImage(with: imageUrl)
            }
            let lblForTitle = cell.viewWithTag(2) as! UILabel
            let setRatingView = cell.viewWithTag(3) as! FloatRatingView
            let lblReview = cell.viewWithTag(4) as! UILabel
            let lblRestTypes = cell.viewWithTag(5) as! UILabel
            let lblForRestaurantAddress = cell.viewWithTag(6) as! UILabel
            let lblDistance = cell.viewWithTag(7) as! UILabel
            let lblPrice = cell.viewWithTag(8) as! UILabel
            cell.backgroundColor = UIColor.clear
            lblForTitle.text = businessData.name
            var strcategories : String = ""
            for index in 0 ..< businessData.categories.count {
                if index == 0 {
                    strcategories = businessData.categories[index].title
                } else {
                    strcategories = strcategories + " , " +  businessData.categories[index].title
                }
            }
            lblRestTypes.text = strcategories
            lblForRestaurantAddress.text = businessData.location!
            lblReview.text =  "\(businessData.review_count!) reviews"
            setRatingView.isUserInteractionEnabled = false
            setRatingView.rating = businessData.rating
            let milesValue = businessData.distance / 1609.344
            let formattedDistance = "\(String(format: "%.2f",milesValue)) mi"
            lblDistance.text = formattedDistance
            lblPrice.text = businessData.price
            super.ratingColorCordination(setRatingView: setRatingView)
            return cell
        } else {
            let cellIdentifier = "cellAddDeal"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let dealsData = profileData.myDeals[indexPath.section]
            let lblCreatedByName = cell.viewWithTag(8) as! UILabel
            let lblDealTitle = cell.viewWithTag(10) as! UILabel
            let lblTime = cell.viewWithTag(11) as! UILabel
            cell.backgroundColor = UIColor.clear
            let trimmedString = "\(dealsData.deals![indexPath.row].dealTitle!.utf8DecodedString())".replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
            lblDealTitle.text = trimmedString
            // print(trimmedString)
            lblTime.text = dealsData.deals![indexPath.row].time
            lblCreatedByName.text = dealsData.deals![indexPath.row].addedBy
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if btnMyFavourite.isSelected {
            let selectedBusinessId = profileData.bussinesses[indexPath.row].bussinessId
            getBusinessDetails(businessId: selectedBusinessId!)
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.reuseIdentifier == "cellAddDeal"{
                let selectedDealId = profileData.myDeals[indexPath.section].deals![indexPath.row].dealId
                getDealDetails(dealId: selectedDealId!)
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnActForFavouriteAndMyDeals(_ sender: UIButton) {
        if  super.guestUserOrNormal() {
            let alert = UIAlertController(title:  "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
                let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.makingRoot("initial")
            }))
            
            present(alert, animated: true, completion: nil)        } else {
            sender.isSelected = true
            var count:Int=0
            if sender.tag == 200 {
                if profileData.bussinesses != nil {
                    count = (profileData.bussinesses?.count)!
                    if count == 1 {
                        lblFavouriteNumber.text = "\(count)" + " " + "Favorite"
                    } else {
                        lblFavouriteNumber.text = "\(count)" + " " + "Favorites"
                    }
                }
            } else {
                if profileData.myDeals != nil {
                    count =  (profileData.myDeals?.count)!
                    if count == 1 {
                        lblFavouriteNumber.text = "\(count)" + " " + "Deal"
                    } else {
                        lblFavouriteNumber.text = "\(count)" + " " + "Deals"
                    }
                }
            }
            for item in buttonTag {
                if item.tag != sender.tag {
                    item.isSelected = false
                }
            }
            showHideNoDataFoundLabel()
            tableView.reloadData()
        }
    }
}
