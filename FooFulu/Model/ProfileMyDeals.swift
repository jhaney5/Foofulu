//
//  ProfileMyDeals.swift
//  FooFulu
//
//  Created by netset on 01/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ProfileMyDeals: Codable {
	var businessId:Int!
	var businessImages:[BusinessImages]!
	var businessName:String!
	var businessRating:Double!
	var businessReviews:Int!
	var businesslocation:String!
	var deals:[DealAddedByDetail]!
}
