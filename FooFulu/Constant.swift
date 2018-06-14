//
//  GlobalConstantClass.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
//var baseURL = "http://192.168.2.15:8080/Foofulu"
//var baseURL = "http://192.168.2.14:8080/Foofulu"


internal struct Constant{
	private enum BaseUrl : String {
		case live
		case dev = "http://112.196.97.229:8080/Foofulu" // http://112.196.97.229:8080/Foofulu/
		case local = "http://192.168.2.85:8081/Foofulu" //http://192.168.2.85:8081/Foofulu/
	}
	
	struct WebServicesApi {
		#if DEBUG
		static let baseUrl = BaseUrl.dev.rawValue
		#else
		static let baseUrl = BaseUrl.dev.rawValue
		#endif
		static let version = ""
		static let signup = WebServicesApi.baseUrl + "/signUp"
		static let login = WebServicesApi.baseUrl + "/login"
		static let socialLogin = WebServicesApi.baseUrl + "/socialLogin"
		static let getBusinessList = WebServicesApi.baseUrl + "/getBussinessesDeals"
		static let getVenuesList = WebServicesApi.baseUrl + "/getVenuesList"
		static let logoutApi = WebServicesApi.baseUrl + "/userLogout"
		static let getBussinessDetails = WebServicesApi.baseUrl + "/getBussinessDetails"
		static let getDealDetails = WebServicesApi.baseUrl + "/getDealDetails"
		static let apiVerifyDeal = WebServicesApi.baseUrl + "/verifyDeal"
		static let getProfileApi = WebServicesApi.baseUrl + "/getProfile"
		static let getOtherProfileApi = WebServicesApi.baseUrl + "/getOtherProfile"
		static let addFavouriteBussiness = WebServicesApi.baseUrl + "/addFavouriteBussiness"
		static let disableDealApi = WebServicesApi.baseUrl + "/disableDeal"
		static let addDeal = WebServicesApi.baseUrl + "/addDeal"
		static let updateProfile = WebServicesApi.baseUrl + "/updateProfile"
		static let updateDeal = WebServicesApi.baseUrl + "/updateDeal"
		static let getToken = WebServicesApi.baseUrl + "/oauth2/token"
		static let getCategoriesAndDays = WebServicesApi.baseUrl + "/getCategoriesAndDays"
		static let addDealApi = WebServicesApi.baseUrl + "/addDeal"
        static let contactUsApi = WebServicesApi.baseUrl + "/contactUs"
		static let searchDeals = WebServicesApi.baseUrl + "/searchDeals"
	}
	
	struct Color {
		static let k_AppNavigationColor: UIColor = UIColor(red: 250.0/255.0, green: 138.0/255.0, blue: 36.0/255.0, alpha: 1.0)
		static let k_ApGrayFontColor: UIColor = UIColor(red: 111.0/255.0, green: 113.0/255.0, blue: 121.0/255.0, alpha: 1.0)
		static let k_AppGrayColor: UIColor = UIColor(red: 213.0/255.0, green: 214.0/255.0, blue: 213.0/255.0, alpha: 1.0)
		static let k_AppSectionColor: UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
		static let k_AppTableViewSeparatorColor: UIColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
		static let k_AppTabBar: UIColor = UIColor(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
		static let k_AppBackColor: UIColor = UIColor(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
		static let k_AppTextFeildPlaceholderColor: UIColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        static let k_AppOrangeColor: UIColor = UIColor(red: 252.0/255.0, green: 137.0/255.0, blue: 0.0/255.0, alpha: 1.0)
	}
	
	//    struct arrForApiHandling {
	//        static var arrForHomeBussiness = NSArray()
	//    }
	
	struct imageSet {
		static var originalImage:UIImage?
	}
	
	struct GlobalVariables {
		
		//static var checkForUserLoginId:String?
		static var checkForBack:String?
		//static var checkForDealAdded:String?
		static var checkForDealEdit:String?
		static var checkForSetting:String?
		static var checkForSearchBar:String?
	}
}

extension UITextField {
	func underlined() {
		DispatchQueue.global(qos: .userInitiated).async {
			// Bounce back to the main thread to update the UI
			DispatchQueue.main.async {
				let layer: CALayer = CALayer()
				layer.borderColor = Constant.Color.k_AppTableViewSeparatorColor.cgColor
				layer.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
				layer.borderWidth = 1
				self.layer.addSublayer(layer)
				self.layer.masksToBounds = true
			}
		}
	}
	
	func setImageLeftSideOnTextfield(image: UIImage) {
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
		imageView.contentMode = .center
		imageView.image = image
		self.leftView = imageView
		self.leftViewMode = UITextFieldViewMode.always
	}
}

extension UIImageView {
	func createCircleForImage () {
		self.layer.cornerRadius = self.frame.size.height/2
		self.clipsToBounds = true
		self.layer.masksToBounds = true
		//self.contentMode = .scaleToFill
	}
    
	func dropShadowForImage(scale: Bool = true) {
		self.layer.borderWidth = 3.2
		self.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
		self.layer.shadowOpacity = 1.0
		self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		self.layer.shadowRadius = 10.0
    }
    
	func setImageFromURl(stringImageUrl url: String){
		if let url = NSURL(string: url) {
			if let data = NSData(contentsOf: url as URL) {
				self.image = UIImage(data: data as Data)
			}
		}
	}
}

extension UILabel {
	func createCornerRadiusForLabel () {
		self.layer.cornerRadius = 8
		self.clipsToBounds = true
		self.layer.masksToBounds = true
		//self.contentMode = .scaleToFill
	}
}

extension UIImage {
	
	public func maskWithColor(color: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()!
		let rect = CGRect(origin: CGPoint.zero, size: size)
		color.setFill()
		self.draw(in: rect)
		
		context.setBlendMode(.sourceIn)
		context.fill(rect)
		
		let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resultImage
	}
}

extension UIButton{
	func borderLayerColor() {
		self.layer.cornerRadius = 4.0
		self.layer.borderWidth = 2.0
		self.layer.borderColor = Constant.Color.k_AppGrayColor.cgColor
		self.clipsToBounds = true
	}
}

extension UIView {
	func cornerRadiusForView() {
		self.layer.cornerRadius = 8.0
		self.clipsToBounds = true
	}
	
	func borderLayerColorView () {
		self.layer.cornerRadius = 8.0
		self.layer.borderWidth = 2.0
		self.layer.borderColor = Constant.Color.k_AppGrayColor.cgColor
		self.clipsToBounds = true
	}
	
	func dropShadow(scale: Bool = true) {
		
		self.layer.borderWidth = 2.0
		self.layer.borderColor = Constant.Color.k_AppGrayColor.cgColor
		self.layer.shadowOpacity = 1.0
		self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		self.layer.shadowRadius = 10.0
		
	}
	
}
