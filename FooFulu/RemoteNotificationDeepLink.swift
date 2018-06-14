//
//  RemoteNotificationDeepLink.swift
//  Foofulu
//
//  Created by netset on 19/02/18.
//  Copyright © 2018 netset. All rights reserved.
//


import UIKit

let RemoteNotificationDeepLinkAppSectionKey : String = "article"

class RemoteNotificationDeepLink: NSObject {
	var article : String = ""
	class func create(userInfo : [NSObject : AnyObject]) -> RemoteNotificationDeepLink?{
		let info = userInfo as NSDictionary
		let articleID = info.object(forKey: RemoteNotificationDeepLinkAppSectionKey) as! String
		var ret : RemoteNotificationDeepLink? = nil
		if !articleID.isEmpty{
			ret = RemoteNotificationDeepLink(articleStr: articleID)
		}
		return ret
	}
	
	private override init(){
		self.article = ""
		super.init()
	}
	
	private init(articleStr: String){
		self.article = articleStr
		super.init()
	}
	
	final func trigger(){
		DispatchQueue.main.async {
			self.triggerImp()
				{ (passedData) in
					print(passedData ?? "")
			}
		}
	}
	
	private func triggerImp(completion: ((AnyObject?)->(Void))){
		completion(nil)
	}
}

