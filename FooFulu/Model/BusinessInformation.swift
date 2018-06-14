//
//  BusinessInformation.swift
//  FooFulu
//
//  Created by netset on 31/01/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class BusinessInformation:Codable{
	var bussinessId:Int!
	var distance:Double!
	var categories:[CategoryDetail]!
	var isFavorite:Bool!
	var location:String!
	var name:String!
	var phone: String!
	var price:String!
	var rating:Double!
	var review_count:Int!
	var photos:[String]!
    var days:[String]!
    var day:String!
    var is_closed : Bool?
    var closing : String?
    var deals:[BusinessInfo]!
    var coordinates : Coordinates?
    var dealDays : [DealDays]?
}
