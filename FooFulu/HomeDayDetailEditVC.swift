//
//  HomeDayDetailEditVC.swift
//  FooFulu
//
//  Created by netset on 11/24/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import Kingfisher
import Branch

class HomeDayDetailEditVC: BaseVC,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollViewImage: UIScrollView!
	let imageViewerScrollView = UIScrollView()
    @IBOutlet weak var lblPaging: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var layoutForScrollHeight: NSLayoutConstraint!
	@IBOutlet weak var timingStatusLabel: UILabel!
    @IBOutlet weak var lblFloatRatingView: FloatRatingView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var lblClosingTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    //   var arrayForHomeDetailViewData = NSDictionary()
    //    var intDealId = Int()
    var sectiontag : NSInteger = 0
	var isComesFromLandingPage = false
    var passBusinessData:Business!
	
    //  var arrForDeals = NSArray()
    //  var arrForDealsId = NSArray()
    //   var valForBusinessId = Int()
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblDriveTime: UILabel!
    
    // var sections = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var headerChk = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(arrayForHomeDetailViewData)
		
        lblFloatRatingView.isUserInteractionEnabled = false
        headerChk = 9
        lblFloatRatingView.rating = passBusinessData.business.rating
		
     //   let milesValue = passBusinessData.business.distance / 1609.344
    //    let formattedDistance = "\(String(format: "%.2f", milesValue)) mi"
        let formattedDistance = "\(String(format: "%.2f", passBusinessData.business.distance))"
        lblDistance.text = "\(String(describing:formattedDistance)) mi"
      //  lblDistance.text = formattedDistance
        lblPrice.text = passBusinessData.business.price
        lblAddress.text = passBusinessData.business.location!
        lblName.text = passBusinessData.business.name!
        lblPhoneNumber.text = passBusinessData.business.phone
        lblReviews.text = String(passBusinessData.business.review_count!)
        super.ratingColorCordination(setRatingView: lblFloatRatingView)
        lblPaging.createCornerRadiusForLabel()
        scrollViewImage.delegate = self
		imageViewerScrollView.delegate = self
		imageViewerScrollView.isPagingEnabled = true
        if passBusinessData.business.isFavorite{
            self.btnFavourite.isSelected = true
        }else{
            self.btnFavourite.isSelected = false
        }
        if passBusinessData.business.is_closed != nil  {
            if passBusinessData.business.is_closed!{
                timingStatusLabel.text = "Closed Today"
                timingStatusLabel.textColor = .red
                lblClosingTime.isHidden = true
            }else{
                lblClosingTime.isHidden = false
                lblClosingTime.text = passBusinessData.business.closing
            }
        } else {
            timingStatusLabel.text = "-"
            lblClosingTime.isHidden = true
        }
		
        //UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.callForScrollView()
		if passBusinessData.business.photos.count < 1 {
			lblPaging.isHidden = true
		}
        lblPaging.text = "\(1)" + " of " + "\(passBusinessData.business.photos.count)" + " >"
    }
	
	@IBAction func scrollTapAction(_ sender: Any) {
		if passBusinessData.business.photos.count > 0 {
			
			var photos = [SSPhoto]()
			
			var urlArray = [URL]()
			
			for item in passBusinessData.business.photos {
				urlArray.append(URL(string: item)!)
			}
			
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

	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}

    func callForScrollView () {
        scrollViewImage.frame = CGRect(x: CGFloat(0), y: 0, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.scrollViewImage.frame.height))
        for i in 0..<passBusinessData.business.photos.count{
            let profileImages = UIImageView()
            profileImages.frame = CGRect(x: CGFloat(self.scrollViewImage.frame.width * CGFloat(i)), y: scrollViewImage.frame.origin.y, width: CGFloat(self.view.frame.size.width), height: 226)
            profileImages.contentMode = .scaleAspectFill
            profileImages.clipsToBounds = true
            profileImages.layer.masksToBounds = true
            let imageString = passBusinessData.business.photos[i]
            if !imageString .isEmpty{
                let imageUrl = URL(string:imageString)
                profileImages.kf.indicatorType = .activity
                profileImages.kf.setImage(with: imageUrl)
                scrollViewImage.addSubview(profileImages)
            }
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {() -> Void in
                self.scrollViewImage.contentSize = CGSize(width: CGFloat(self.scrollViewImage.frame.width * CGFloat(i + 1)), height: 226)
            }, completion: {(_ finished: Bool) -> Void in
            })
            scrollViewImage.showsHorizontalScrollIndicator = false
        }
    }
	
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.size.width
        let page:Int = Int((scrollViewImage.contentOffset.x + width)/width)
        lblPaging.text = "\(page)" + " of " + "\(passBusinessData.business.photos.count)" + " >"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return passBusinessData.business.dealDays!.count
    }
	
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 15, width:
            tableView.bounds.size.width, height: 20))
        //headerLabel.font = headerLabel.font.withSize(12)
        headerLabel.textColor = UIColor.black
        headerLabel.text = passBusinessData.business.dealDays![section].day
        // headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: tableView.bounds.size.width-30, y: 15, width: 20, height: 20)
        headerView.addSubview(imgView)
        btn.tag = section
        if btn.tag == headerChk {
            imgView.image = #imageLiteral(resourceName: "down_arrow")
        } else {
            imgView.image = #imageLiteral(resourceName: "arrowRight")
        }
        
        btn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        //for i in 0..<sections.count {
        headerLabel.font = UIFont(name:("Arial"), size: 18)
        //}
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(btn)
        
        let lblName = UILabel()
        lblName.frame = CGRect.init(x: 0, y: 48, width: headerView.frame.size.width, height: 2)
        lblName.backgroundColor = Constant.Color.k_AppBackColor
        headerView.addSubview(lblName)
        return headerView
    }
    
    func handleTap(sender: UIButton) {
        sectiontag=sender.tag
        if headerChk == sender.tag {
            headerChk = 150
        }else {
            headerChk = sender.tag
        }
        UIView.transition(with: self.view, duration: 0.6, options: UIViewAnimationOptions.curveEaseInOut, animations: {() -> Void in
            self.tableView.reloadData()
        }) { _ in }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if headerChk < 9 {
            if sectiontag==section {
                return (passBusinessData.business.dealDays![section].deals!.count)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell: tableViewCellDays = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! tableViewCellDays
        cell.backgroundColor = Constant.Color.k_AppBackColor
        
        let string : String = passBusinessData.business.dealDays![indexPath.section].deals![indexPath.row].title!.utf8DecodedString()
        let trimmedString = string.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
        cell.labelTitle.text = trimmedString

        cell.dealCountLabel.text = "\(indexPath.row + 1)."
        for btnDay in cell.stackViewForDays.subviews {
            let btnDay = btnDay as! FooFuluButton
            btnDay.backgroundColor = UIColor.lightGray
            btnDay.titleLabel?.textColor = UIColor.white
            let selectedDay : [Days] = passBusinessData.business.dealDays![indexPath.section].deals![indexPath.row].days!
            for day in selectedDay {
                if day.id == btnDay.tag {
                    btnDay.backgroundColor = Constant.Color.k_AppNavigationColor
                    btnDay.titleLabel?.textColor = UIColor.white
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        getDealDetails(dealId:passBusinessData.business.dealDays![indexPath.section].deals![indexPath.row].dealId!)
    }
    
    func getDealDetails (dealId:Int) {
        let params:NSDictionary = [
            "dealId" : dealId
        ]
        super.showAnloaderFunct (text:"Fetching data..")
        super.postDataMultipleArrayServiceWithParameters(requestUrl:Constant.WebServicesApi.getDealDetails, params:params) { (responseObject) -> Void in
            print(responseObject)
            do {
                let objEditHomeDealVC :EditHomeDealVC = self.storyboard?.instantiateViewController(withIdentifier: "EditHomeDealVC") as! EditHomeDealVC
                objEditHomeDealVC.selectedDealDetail = try JSONDecoder().decode(DealDetail.self, from:responseObject)
                self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
            } catch let jsonError {
                print("error",jsonError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 80
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Button Action
    
    @IBAction func buttonActForShare(_ sender: Any) {
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
		let imageString = passBusinessData.business.photos[0]
		let url = URL(string:imageString)
		getDataFromUrl(url: url!) { data, response, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() {
				var imageShare = UIImage()
				imageShare = UIImage(data: data)! //check
				self.createLink(imageShare: imageShare)
			}
		}
	}
	
	func createLink(imageShare: UIImage) {
		let buo = BranchUniversalObject.init()
		buo.title = "Foofulu"
		buo.contentMetadata.customMetadata["bussinessId"] = passBusinessData.business.bussinessId
		let linkProperties = BranchLinkProperties.init()
		linkProperties.channel = "Foofulu"
		buo.getShortUrl(with: linkProperties) { (urlString: String?, error: Error?) in
			if let s = urlString {
				let branchURL:URL?
				branchURL = URL.init(string: s)
				self.callActivity(linkToShare:branchURL!)
			} else {
			}
		}
	}
	
	func callActivity(linkToShare:URL) {
		let objectsToShare = [linkToShare] as [Any]
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
    
	
    
    @IBAction func btnActForFavourite(_ sender: UIButton) {
        if  super.guestUserOrNormal() {
			let alert = UIAlertController(title: "Alert", message:generalStrings.message.rawValue , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			present(alert, animated: true, completion: nil)        } else {
            self.apiForAddFavouriteAndNonFavourite()
            if sender.isSelected {
                sender.isSelected = false
            } else {
                sender.isSelected = true
            }
        }
    }
    
    func apiForAddFavouriteAndNonFavourite () {
        let params:NSDictionary = [
            "bussinessId" : passBusinessData.business.bussinessId
        ]
        print(params)
        super.showAnloaderFunct (text:"Fetching data..")
        super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.addFavouriteBussiness, params: params) { (responseObject) -> Void in
            print(responseObject)
            // super.alertViewController(title: "Message!", message: responseObject.value(forKey: "message"))
        }
    }
    
    @IBAction func tapCallingActivityAct(_ sender: Any) {

            if let url = URL(string: "tel://\(lblPhoneNumber.text!)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                alertViewController(title: "", message: "Your device doesn't support this feature.")
            }
        }
	
    @IBAction func tapgetDirectionsAct(_ sender: Any) {
        self.openDestinationLocationOnMap()
    }
    
    func openDestinationLocationOnMap(){
        let lat = (passBusinessData.business.coordinates?.latitude)!
        let longi = (passBusinessData.business.coordinates?.longitude)!
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!){
            let urlString = "http://maps.google.com/?daddr=\(lat),\(longi))&directionsmode=driving"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }else{
            let urlString = "http://maps.apple.com/maps?daddr=\(lat),\(longi))&dirflg=d"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnActForBack(_ sender: Any) {
		if isComesFromLandingPage{
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
			appDelegate.window?.rootViewController = objMain
		}else{
			_ = navigationController?.popViewController(animated: true)
		}
    }
}

class tableViewCellDays: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var stackViewForDays: UIStackView!
	@IBOutlet weak var dealCountLabel: UILabel!
}

extension UIScrollView {
	var currentPage:Int{
		return Int(self.contentOffset.x/self.frame.width)
	}
}

