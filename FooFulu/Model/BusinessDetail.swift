//
//  BusinessDetail.swift
//  FooFulu
//
//  Created by netset on 25/01/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class BusinessDetail: Codable {
	var id:String?
	var bussinessId:String?
	var name:String?
	var image_url:String?
	var is_closed:Bool?
	var url:String?
	var review_count:Int?
	var rating:Double?
	var price:String?
	var phone:String?
	var display_phone:String?
	var distance:Double?
	var location:location?
}
