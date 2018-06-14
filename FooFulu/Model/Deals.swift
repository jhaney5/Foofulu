
//
//  Deals.swift
//  FooFulu
//
//  Created by netset on 07/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

struct Deals : Codable {
	var deals:[SearchDeal]?
	var vrified : Int?
	//var objAddedBy : ObjAddedBy?
//	var images : [Images]?
//	var updatedBy : UpdatedBy?
	var verifiedByMe : Bool?
	var business : Business?
	var dealId : Int?
	var days : [Days]?
	var title : String?
	var dealcategories : [Dealcategories]?
	//var lastVerifiedBy : LastVerifiedBy?
}
