//
//  DestinationData.swift
//  ExpandingTableView
//
//  Created by Thomas Walker on 04/12/2016.
//  Copyright © 2016 CodeBaseCamp. All rights reserved.
//

import Foundation

public class DestinationData {
    
    public var name: String
    public var type: String
    public var imgFood: String
    public var address: String
    public var rate: Float
    public var flights: [FlightData]?
    
    init(name: String,type:String,imgFood:String, address:String, rate:Float, flights: [FlightData]?) {
        self.name = name
        self.type = type
        self.imgFood = imgFood
        self.address = address
        self.rate = rate
        self.flights = flights
    }
}

public class FlightData {
    public var orderName: String

    init(orderName: String) {
        self.orderName = orderName
    }
}
