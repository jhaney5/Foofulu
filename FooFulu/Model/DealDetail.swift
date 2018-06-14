//
//  DealDetail.swift
//  FooFulu
//
//  Created by netset on 31/01/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class DealDetail:Codable {
	var dealId:Int!
	var days:[Days]!
	var dealcategories:[DealCategory]!
	var images:[DealImages]!
	var objAddedBy:DealAddedByInfo!
	var title:String!
	var lastVerifiedBy:LastVarifiedByDetail!
	var verifiedByMe:Bool!
	var vrified:Int!
    var business:BusinessInfo!
}
