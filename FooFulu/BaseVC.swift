//
//  BaseVC.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit
import Alamofire
import EZLoadingActivity
import AVFoundation


class BaseVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	//MARK:- CONSTANT(S)
	var picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().isTranslucent = false
        self.tabBarController?.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnloaderFunct (text:String) {
        IDProgressHUD.shared.showHudAnimation    = .growIn
        IDProgressHUD.shared.backgroundColor     = .black
        IDProgressHUD.shared.dismissHudAnimation = .growOut
        IDProgressHUD.shared.indicatorColor      = .orange
        IDProgressHUD.shared.showHUD()
    }
    
    func hideAnloaderFunct () {
        IDProgressHUD.shared.hideHUD()
    }
    
    // MARK: - EmailValidation
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func  ratingColorCordination (setRatingView:FloatRatingView) {
        if setRatingView.rating < 4 {
            setRatingView.fullImage? = #imageLiteral(resourceName: "StarFull").maskWithColor(color: UIColor.orange)
        } else {
            setRatingView.fullImage? = #imageLiteral(resourceName: "StarFull").maskWithColor(color: UIColor.red)
        }
        setRatingView.emptyImage = #imageLiteral(resourceName: "StarFull").maskWithColor(color: UIColor.gray)
    }
    
	func backBtnWithNavigationTitle(title : String) {
        self.title = title as String
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBack"), style: .plain, target: self, action:#selector(BaseVC.backToView))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor .white
    }
    
    func backToView() {
        _ = navigationController?.popViewController(animated: true)
    }
	
	func galleryAlert() {
		let imageController = UIImagePickerController()
		imageController.isEditing = false
		imageController.delegate = self
		
		let optionMenu = UIAlertController(title: nil, message: "Choose Image", preferredStyle: .actionSheet)
		
		let fromGalleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
			self.present(imageController, animated: true, completion: nil)
			print("Upload From Gallery")
		})
		
		let fromCameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
				imageController.sourceType = UIImagePickerControllerSourceType.camera
				self.present(imageController, animated: true, completion: nil)
				print("Take Photo")
			}
			else {
				let alert = UIAlertController(title: "Error !!!", message: "Camera not available", preferredStyle: .alert)
				print("Camera not available")
				let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
					(alert: UIAlertAction!) -> Void in
					print("Cancel")
				})
				alert.addAction(okAction)
				self.present(alert, animated: true, completion: nil)
			}
		})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
			print("Cancel")
		})
		
		optionMenu.addAction(fromGalleryAction)
		optionMenu.addAction(fromCameraAction)
		optionMenu.addAction(cancelAction)
		self.present(optionMenu, animated: true, completion: nil)
	}
	
	// MARK: - Image Picker Delegate
    func alertViewController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
	func openCameraSheet() {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
			self.checkCameraPermission()
		}))
		actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
			self.openGallary()
		}))
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	func checkCameraPermission()  {
			AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
				if granted == true {
					self.openCamera()
				} else {
					self.noCameraFound()
				}
			})
		}
	
	func noCameraFound(){
		let alert = UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Camera Permission for this app.", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
		}));
		alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
			UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	//MARK:- Image Tapped Method
	func openGallary(){
		picker.allowsEditing = true
		picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	func openCamera(){
		if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
			picker.allowsEditing = true
			picker.sourceType = UIImagePickerControllerSourceType.camera
			picker.cameraCaptureMode = .photo
			present(picker, animated: true, completion: nil)
		}else{
			let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
			alert.addAction(ok)
			present(alert, animated: true, completion: nil)
		}
	}
	
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        Constant.imageSet.originalImage = image
        picker.dismiss(animated: false, completion: {() -> Void in
             // self.callEditor(GlobalConstantClass.imageSet.originalImage!)
        })
    }
	
    /****************************************** time set function ****************************************************/
    
    func timeAgoSinceDate(_ strDate:String, numericDates:Bool = false) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date: Date = formatter.date(from: strDate)!
        
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    func convertDateToTime(strDate:String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: strDate)
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: date!)
    }
    
    func changeFormatToHH_MM(time: String)-> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = formatter.date(from:time)
        formatter.dateFormat = "HH:mm"
        return  formatter.string(from: date!)
    }
    
    
    func guestUserOrNormal() -> Bool {
        if UserDefaults.standard.value(forKey: "secretKey") as! String == generalStrings.guestSecretKey.rawValue {
            return true
        }
        return false
    }
    
    /********************************************* MARK : API *******************************************************/
    // MARK : Upload images
    
    func postServiceForUploadImages (requestUrl:String, image:UIImage, imageParam:String, params:NSDictionary, callback:@escaping ( _ data: Dictionary<String, AnyObject>?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            var headers = HTTPHeaders()
            UIApplication.shared.isIdleTimerDisabled = true
            headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)! , "version":self.getVersion(), "deviceType":"IOS"]
            self.showAnloaderFunct(text: "dsffdf")
            let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: imageParam, fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                print(params)
                for (key, value) in params {
                    print(key)
                    print(value)
                    multipartFormData.append(((value as AnyObject) as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key as! String)
                }
            },
                             usingThreshold:UInt64.init(),
                             to:requestUrl,
                             method:.post,
                             headers: headers,
                             encodingCompletion: { responseObject in
                                switch responseObject
                                {
                                case .success(let upload, _, _):
                                    self.hideAnloaderFunct()
                                    upload.responseJSON { response in
                                        for i in 200..<300
                                        {
                                            if(response.response?.statusCode == i){
                                                //    self.hideHUD()
                                                self.hideAnloaderFunct()
                                                UIApplication.shared.isIdleTimerDisabled = false
                                                debugPrint(response.result.value!)
                                                callback(response.result.value! as? Dictionary<String, AnyObject>)
                                                break
                                            }
                                            else{
                                                self.hideAnloaderFunct()
                                                //       self.hideHUD()
                                              //  print(response)
                                                UIApplication.shared.isIdleTimerDisabled = false
                                              //  self.errorBlock(dataResponse: response.result.value as! DataResponse<Any>)
                                                break
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    //   self.hideHUD()
                                    self.hideAnloaderFunct()
                                    UIApplication.shared.isIdleTimerDisabled = false
                                    self.failureErrorBlock(message: error.localizedDescription)
                                    
                                }
            })
            
        } else {
            self.openPhoneSetting()
        }
    }
	
	func postServiceForUploadImagesArray (requestUrl:String, imagesArray:[UIImage], params:NSDictionary, callback:@escaping ( _ data: Data) -> Void) {
		Logger.log("")
		Logger.log("")
		Logger.log("===========================================")
		Logger.log("Url = \(requestUrl)")
		Logger.log("Parameters = \(String(describing: params))")
		Logger.log("============================================")
		Logger.log("")
		Logger.log("")
		if Reachability.isConnectedToNetwork() {
			var headers = HTTPHeaders()
			UIApplication.shared.isIdleTimerDisabled = true
			headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)!, "version":self.getVersion(), "deviceType":"IOS"]
			self.showAnloaderFunct(text: "dsffdf")
			Alamofire.upload(multipartFormData: { (multipartFormData) in
					if imagesArray.count > 0{
						let myImageName = "\(Date()).png"
						let str = myImageName.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines)
						var str1 = str.replacingOccurrences(of: " ", with: "")
						for index in 0..<imagesArray.count{
							let imageData2 = UIImageJPEGRepresentation(imagesArray[index], 0.5)
							print(imageData2!)
							str1 = str1 + String(index)
							multipartFormData.append(imageData2!, withName: "images", fileName: str1.appending(".jpg"), mimeType: "image/jpg")
						}
					}
				for (key, value) in params {
					multipartFormData.append(((value as AnyObject) as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key as! String)
				}
			},
							 usingThreshold:UInt64.init(),
							 to:requestUrl,
							 method:.post,
							 headers: headers,
							 encodingCompletion: { responseObject in
								switch responseObject{
								case .success(let upload, _, _):
									upload.responseJSON { response in
										self.hideAnloaderFunct()
										let serverData = String(data: response.data!, encoding: String.Encoding.utf8)
										Logger.log("")
										Logger.log("")
										Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
										Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
										Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
										Logger.log("")
										Logger.log("")
										for i in 200..<300{
											if(response.response?.statusCode == i){
												self.hideAnloaderFunct()
												UIApplication.shared.isIdleTimerDisabled = false
												callback(response.data!)
												break
											}else{
												self.hideAnloaderFunct()
												UIApplication.shared.isIdleTimerDisabled = false
												self.errorBlock(dataResponse: response)
												break
											}
										}
									}
								case .failure(let error):
									self.hideAnloaderFunct()
									UIApplication.shared.isIdleTimerDisabled = false
									self.failureErrorBlock(message: error.localizedDescription)
								}
			})
		} else {
			self.openPhoneSetting()
		}
	}
    
    // MARK : Put service API
    
    func putServiceForUploadImages (requestUrl:String, image:UIImage, imageParam:String, params:NSDictionary, callback:@escaping ( _ data: Dictionary<String, AnyObject>?) -> Void)  {
        if Reachability.isConnectedToNetwork() {
            
            var headers = HTTPHeaders()
            
            let fileName = Date().stringDate(format: "ddmmyyyyhhmmss")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: imageParam, fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
            },
                             usingThreshold:UInt64.init(),
                             to:requestUrl,
                             method:.put,
                             headers: headers,
                             encodingCompletion: { (responseObject) in
                                switch responseObject {
                                case .success(let upload, _, _) :
                                    upload.responseJSON { response in
                                        for i in 200..<300 {
                                            if response.response?.statusCode == i {
                                                callback(response.result.value! as? Dictionary<String, AnyObject>)
                                            }
                                            else {
                                                self.errorBlock(dataResponse: response.result.value as! DataResponse<Any>)
                                            }
                                        }
                                    }
                                case .failure(let error) :
                                    self.failureErrorBlock(message: error.localizedDescription)
                                }
                                
            })
        } else {
            self.openPhoneSetting()
        }
    }
    
    // MARK : web service for patch method
    
    func patchServiceWithParameters(requestUrl : String , params : NSDictionary , callback:@escaping ( _ data: NSArray) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            UIApplication.shared.isIdleTimerDisabled = true
            //          self.showHUD()
            var headers = HTTPHeaders()
            headers = ["version":self.getVersion(), "deviceType":"IOS"]
            //            if !GlobalConstantClass.api_secret.value.isEmpty{
            //                headers = ["APISECRET": GlobalConstantClass.api_secret.value,
            //                           "Content-Type":"application/json"]
            //            }
            print(params)
            Alamofire.request(requestUrl, method: .patch, parameters: params as? Parameters, encoding:  URLEncoding.queryString, headers: headers ).responseJSON
                { responseObject in
                    print(responseObject)
                    UIApplication.shared.isIdleTimerDisabled = false
                    //    self.hideHUD()
                    switch responseObject.result{
                    case .success(let value):
                        print(value)
                        if responseObject.response?.statusCode == 200  {
                            let result = value as! NSArray
                            callback(result)
                        }
                        else {
                            self.errorBlock(dataResponse: responseObject)
                        }
                    case .failure(let error):
                        UIApplication.shared.isIdleTimerDisabled = false
                        //    self.hideHUD()
                        self.failureErrorBlock(message: error.localizedDescription)
                        break
                    }
            }
        }
        else {
            self.openPhoneSetting()
        }
    }
    
    // MARK: webservice for post method
    
	func postServiceWithParameter(requestURL : String, params : Parameters?, callBack: @escaping(_ data: Dictionary<String,AnyObject>?) -> Void){
        if Reachability.isConnectedToNetwork() {
            var headers = HTTPHeaders()
            headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)!,
                       "Content-Type":"application/json", "version":self.getVersion(), "deviceType":"IOS"]
            print(params)
            Alamofire.request(requestURL, method: .post, parameters:  params, encoding: URLEncoding.queryString, headers: headers).responseJSON { responseObject in
                switch responseObject.result{
                case .success(let value):
                    print(value)
                    self.hideAnloaderFunct()
                    let result = value as! NSDictionary
                    for i in 200..<300 {
                        self.hideAnloaderFunct()
                        if responseObject.response?.statusCode == i{
                            callBack(result as? Dictionary<String, AnyObject>)
                            break
                        } else {
                            self.errorBlock(dataResponse: responseObject)
                            break
                        }
                    }
                case .failure(let error):
                    self.hideAnloaderFunct()
                    self.failureErrorBlock(message: error.localizedDescription)
                    break
                }
            }
        } else {
            self.openPhoneSetting()
        }
    }
    
	// MARK : webservice for get method
	func getService(requestURL:String, callBack: @escaping(_ data: Data) -> Void){
		if Reachability.isConnectedToNetwork() {
			self.showAnloaderFunct(text: "Loading..")
			var headers = HTTPHeaders()
//			headers = ["Authorization": "\(token)"]
			headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)!,
					   "Content-Type":"application/json", "version":self.getVersion(), "deviceType":"IOS"]
			Logger.log("")
			Logger.log("")
			Logger.log("===========================================")
			Logger.log("Url = \(requestURL)")
			Logger.log("Headers = \(headers)")
			Logger.log("============================================")
			Logger.log("")
			Logger.log("")
			Alamofire.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
				let serverData = String(data: responseObject.data!, encoding: String.Encoding.utf8)
				Logger.log("")
				Logger.log("")
				Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
				Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
				Logger.log("Response Error  \(String(describing: responseObject.result.error))")
				Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
				Logger.log("")
				Logger.log("")
				UIApplication.shared.isIdleTimerDisabled = false
				self.hideAnloaderFunct()
				switch responseObject.result {
				case .success(let value):
					print(value)
					for i in 200..<300 {
						if responseObject.response?.statusCode == i {
							callBack(responseObject.data!)
							break
						} else {
							self.errorBlock(dataResponse: responseObject)
							break
						}
					}
				case.failure(let error):
					self.hideAnloaderFunct()
					self.failureErrorBlock(message: error.localizedDescription)
					break
				}
			}
		} else {
			self.openPhoneSetting()
		}
	}
    
    // MARK: - WebService for Put Method
    
    func putServiceWithParameters(requestUrl : String , params : NSDictionary , callback:@escaping ( _ data: Dictionary<String, AnyObject>?) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            UIApplication.shared.isIdleTimerDisabled = true
            //     self.showHUD()
            var headers = HTTPHeaders()
            headers = ["version":self.getVersion(), "deviceType":"IOS"]
            //            if !GlobalConstantClass.api_secret.value.isEmpty{
            //                headers = ["APISECRET": GlobalConstantClass.api_secret.value,
            //                           "Content-Type":"application/json"]
            //            }
            print(params)
            Alamofire.request(requestUrl, method: .put, parameters: params as? Parameters, encoding:  URLEncoding.queryString, headers: headers ).responseJSON
                {
                    responseObject in
                    
                    print(responseObject)
                    UIApplication.shared.isIdleTimerDisabled = false
                    //          self.hideHUD()
                    switch responseObject.result{
                    case .success(let value):
                        let result = value as! NSDictionary
                        if responseObject.response!.statusCode == 200{
                            callback(result as? Dictionary<String, AnyObject>)
                        }
                        else {
                            self.errorBlock(dataResponse: responseObject)
                        }
                    case .failure(let error):
                        UIApplication.shared.isIdleTimerDisabled = false
                        //          self.hideHUD()
                        self.failureErrorBlock(message: error.localizedDescription)
                        break
                    }
            }
        } else {
            self.openPhoneSetting()
        }
    }

    // MARK: - WebService for Post multiple Array Method
//	func POSTYelpServiceWithParameters(params : Parameters,searchText:String?,latitude:Double,longitude:Double, callback:@escaping (_ data: Data) -> Void) {
//
//		let headers = ["Content-Type": "application/x-www-form-urlencoded"]
//		let requestUrl = "https://api.yelp.com/oauth2/token"
//		Logger.log("")
//		Logger.log("")
//		Logger.log("===========================================")
//		Logger.log("Url = \(requestUrl)")
//		Logger.log("Headers = \(headers)")
//		Logger.log("Parameters = \(params)")
//		Logger.log("============================================")
//		Logger.log("")
//		Logger.log("")
//		if Reachability.isConnectedToNetwork() == true {
//			UIApplication.shared.isIdleTimerDisabled = true
//			self.showAnloaderFunct(text: "Loading..")
//		Alamofire.request(requestUrl, method: .post, parameters: params as? Parameters , encoding: URLEncoding.httpBody, headers: headers ).responseJSON
//			{ responseObject in
//				print(responseObject)
//				let serverData = String(data: responseObject.data!, encoding: String.Encoding.utf8)
//				Logger.log("")
//				Logger.log("")
//				Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//				Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
//				Logger.log("Response Error  \(String(describing: responseObject.result.error))")
//				Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
//				Logger.log("")
//				Logger.log("")
//
//				switch responseObject.result{
//				case .success(let value):
//					let result = value as! NSDictionary
//					if responseObject.response!.statusCode == 200{
//						print(result as AnyObject)
//						self.getServices(Authorization:result as NSDictionary ,searchText: searchText,latitude: latitude,Longitude: longitude, callback: {
//							(responseObject) -> Void in
//							print(responseObject)
//							callback(responseObject)
//						})
//
//					}
//					else{
//                        self.hideAnloaderFunct()
//						self.errorBlock(dataResponse: responseObject)
//					}
//
//				case .failure(let error):
//                    self.hideAnloaderFunct()
//					print(error)
//					break
//				}
//			}
//		}
//	}
	
	func POSTYelpServiceWithParameters(params : Parameters,searchText:String?,latitude:Double,longitude:Double, callback:@escaping (_ data: Data) -> Void) {
		var headers = HTTPHeaders()
		headers = ["Authorization":"Bearer ameWBKnfh_me4DnzQ9Ak40nZjgdrKedUBMT9kKCYYxaIk63hi_Gzf1AecJAaL8M6_8G2qcMJJexWdwXHvqkTBZNhgiEq0CTMmQfTdSjyFsGkX5PZbKaI7HqTVrQEWnYx"]
		let url:String!
		if searchText == "" {
			url = "\("https://api.yelp.com/v3/businesses/search?latitude=")\(latitude)\("&longitude=")\(longitude)\("&sort_by=distance&limit=50&radius=4000&categories=bars,nightlife,restaurants")"
//			 url = "https://api.yelp.com/v3/businesses/search?latitude=39.166307&longitude=-86.528031&sort_by=distance&limit=50&radius=4000&categories=bars,nightlife,restaurants"
		} else {
			// url = "https://api.yelp.com/v3/businesses/search?latitude=40.7128&longitude=-74.0060&sort_by=distance&limit=50&radius=4000&categories=bars,nightlife,restaurants&term=\(String(describing: searchText!))"
            
          url =  "\("https://api.yelp.com/v3/businesses/search?latitude=")\(latitude)\("&longitude=")\(longitude)\("&sort_by=distance&limit=50&radius=4000&categories=bars,nightlife,restaurants&term=")\(String(describing: searchText!))"
		}
		Logger.log("")
		Logger.log("")
		Logger.log("===========================================")
		Logger.log("Url = \(url)")
		Logger.log("Headers = \(headers)")
		Logger.log("============================================")
		Logger.log("")
		Logger.log("")
		print(headers)
		if Reachability.isConnectedToNetwork() == true {
			self.showAnloaderFunct(text: "Loading..")
			UIApplication.shared.isIdleTimerDisabled = true
		     Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
			.responseJSON { responseObject in
				let serverData = String(data: responseObject.data!, encoding: String.Encoding.utf8)
				Logger.log("")
				Logger.log("")
				Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
				Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
				Logger.log("Response Error  \(String(describing: responseObject.result.error))")
				Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
				Logger.log("")
				Logger.log("")
				self.hideAnloaderFunct()
				switch responseObject.result{
				case .success(let value):
					self.hideAnloaderFunct()
					print(value)
					if responseObject.response!.statusCode == 200{
						print(value as AnyObject)
						callback(responseObject.data!)
					}else{
						self.hideAnloaderFunct()
					}
				case .failure(let error):
					self.hideAnloaderFunct()
					print(error)
					break
				}
			}
		} else {
			self.openPhoneSetting()
		}
	}
    
    func postMultipleArrayServiceWithParameters(requestUrl : String,params : AnyObject, callback:@escaping ( _ data: AnyObject) -> Void){
		var headers = HTTPHeaders()
		if (UserDefaults.standard.value(forKey: "secretKey") as? String == nil) {
			headers = ["Content-Type":"application/json", "version":self.getVersion(), "deviceType":"IOS"]
		} else {
			headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)!,
					   "Content-Type":"application/json", "version":self.getVersion(), "deviceType":"IOS"]
		}
//		headers = ["Content-Type":"application/x-www-form-urlencoded"]

		Logger.log("")
		Logger.log("")
		Logger.log("===========================================")
		Logger.log("Url = \(requestUrl)")
		Logger.log("Headers = \(headers)")
		Logger.log("Parameters = \(params)")
		Logger.log("============================================")
		Logger.log("")
		Logger.log("")
        if Reachability.isConnectedToNetwork() == true {
            UIApplication.shared.isIdleTimerDisabled = true
            self.showAnloaderFunct(text: "Loading..")
            Alamofire.request(requestUrl, method: .post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { responseObject in
					let serverData = String(data: responseObject.data!, encoding: String.Encoding.utf8)
					Logger.log("")
					Logger.log("")
					Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
					Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
					Logger.log("Response Error  \(String(describing: responseObject.result.error))")
					Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
					Logger.log("")
					Logger.log("")
					UIApplication.shared.isIdleTimerDisabled = false
                    self.hideAnloaderFunct()
                    switch responseObject.result{
                    case .success(let value):
                        self.hideAnloaderFunct()
                        print(value)
                        if responseObject.response!.statusCode == 200 {
                            callback(value as AnyObject)
                        } else {
                            self.errorBlock(dataResponse: responseObject)
                        }
                    case .failure(let error):
                        UIApplication.shared.isIdleTimerDisabled = false
                        self.hideAnloaderFunct()
                        self.failureErrorBlock(message: error.localizedDescription)
                        break
                    }
            }
        } else {
            self.openPhoneSetting()
        }
    }
    
    func getVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }
    
	
	func postDataMultipleArrayServiceWithParameters(requestUrl : String,params : AnyObject, callback:@escaping ( _ data: Data) -> Void){
		var headers = HTTPHeaders()
		if (UserDefaults.standard.value(forKey: "secretKey") as? String == nil) {
            headers = ["Content-Type":"application/json", "version":self.getVersion(), "deviceType":"IOS"]
		} else {
			headers = ["secretKey": (UserDefaults.standard.value(forKey: "secretKey") as? String)!,
					   "Content-Type":"application/json", "version":self.getVersion() , "deviceType":"IOS"]
		}
		//		headers = ["Content-Type":"application/x-www-form-urlencoded"]
		Logger.log("")
		Logger.log("")
		Logger.log("===========================================")
		Logger.log("Url = \(requestUrl)")
		Logger.log("Headers = \(headers)")
		Logger.log("Parameters = \(params)")
		Logger.log("============================================")
		Logger.log("")
		Logger.log("")
		if Reachability.isConnectedToNetwork() == true {
			UIApplication.shared.isIdleTimerDisabled = true
			self.showAnloaderFunct(text: "Loading..")
			Alamofire.request(requestUrl, method: .post, parameters: params as? Parameters, encoding: JSONEncoding.default, headers: headers)
				.responseJSON { responseObject in
					let serverData = String(data: responseObject.data!, encoding: String.Encoding.utf8)
					Logger.log("")
					Logger.log("")
					Logger.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
					Logger.log("Server response  \(serverData?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "") ?? "" )")
					Logger.log("Response Error  \(String(describing: responseObject.result.error))")
					Logger.log("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
					Logger.log("")
					Logger.log("")
					UIApplication.shared.isIdleTimerDisabled = false
					self.hideAnloaderFunct()
					switch responseObject.result{
					case .success(let value):
						self.hideAnloaderFunct()
						print(value)
						if responseObject.response!.statusCode == 200 {
							callback(responseObject.data!)
						}else{
							self.errorBlock(dataResponse: responseObject)
						}
					case .failure(let error):
						UIApplication.shared.isIdleTimerDisabled = false
						self.hideAnloaderFunct()
						self.failureErrorBlock(message: error.localizedDescription)
						break
					}
			}
		} else {
			self.hideAnloaderFunct()
			self.openPhoneSetting()
		}
	}
	
    
    // MARK : Webservice for delete method
    
    func deleteServiceWithParameters(requestUrl : String, callback:@escaping ( _ data: AnyObject) -> Void) {
        if Reachability.isConnectedToNetwork() == true {
            UIApplication.shared.isIdleTimerDisabled = true
            //       self.showHUD()
            var headers = HTTPHeaders()
            headers = ["version":self.getVersion(), "deviceType":"IOS"]
            //            if !GlobalConstantClass.api_secret.value.isEmpty{
            //                headers = ["APISECRET": GlobalConstantClass.api_secret.value]
            //            }
            
            Alamofire.request(requestUrl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { responseObject in
                    UIApplication.shared.isIdleTimerDisabled = false
                    //       self.hideHUD()
                    
                    switch responseObject.result {
                    case .success(let value):
                        print(value)
                        if responseObject.response!.statusCode == 200 {
                            callback(value as AnyObject)
                        } else {
                            self.errorBlock(dataResponse: responseObject)
                        }
                        
                    case .failure(let error):
                        UIApplication.shared.isIdleTimerDisabled = false
                        //              self.hideHUD()
                        self.failureErrorBlock(message: error.localizedDescription)
                        break
                    }
            }
        } else {
            self.openPhoneSetting()
        }
    }

    // MARK : Handle failure block
    func failureErrorBlock(message:String) {
        if message == "Response status code was unacceptable: 401." {
            let alert = UIAlertController(title:"Session Expired", message:"Session Expired try to Re-login?"  , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: {action in
                let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.makingRoot("initial")
            }))
            present(alert, animated:true, completion: nil)
		} else {
            self.alertViewController(title:"Failure", message: message)
        }
    }
    
    // MARK : Handle error block
    
    func errorBlock(dataResponse : DataResponse<Any>)  {
		let result = dataResponse.result.value as! NSDictionary
        let message = result.value(forKey: "message") as! String
        if dataResponse.response?.statusCode == 401 {
			if message == "We can not seem to find an account with that email." {
				let alert = UIAlertController(title:  "Alert", message:message  , preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style:.default, handler: {action in
					let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
					objAppDelegate?.makingRoot("initial")
				}))
				present(alert, animated: true, completion: nil)
			} else {
				let alert = UIAlertController(title:  "Session Expired", message:"Session Expired try to Re-login?"  , preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style:.default, handler: {action in
					let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
					objAppDelegate?.makingRoot("initial")
				}))
				present(alert, animated: true, completion: nil)
			}
		} else if message == "You need to sign up to post a deal."{
			let alert = UIAlertController(title:  "Failure", message:message  , preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
			}))
			alert.addAction(UIAlertAction(title: "Sign In Now", style:.default, handler: {action in
				let objAppDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
				objAppDelegate?.makingRoot("initial")
			}))
			present(alert, animated: true, completion: nil)
		} else {
            self.alertViewController(title: "Failure", message:message)
        }
    }
    
    // MARK : Open Settings
    func openPhoneSetting (){
        let alertController = UIAlertController (title: "Network Error!", message: "Internet connection appears to be offline. Please check your network connectivity", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) -> Void in
            guard let settingUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, completionHandler: { (success) in
                        print("Setting open: \(success)")
                    })
                }else{
                    print("Failure occured")
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    func stringDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
