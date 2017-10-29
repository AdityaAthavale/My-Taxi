//
//  VehicalModel.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/27/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import Foundation
import CoreLocation

@objc class Vehical : NSObject {
    @objc var type : String?
    @objc var state : String?
    @objc var id: String?
    @objc var heading : NSNumber?
    @objc var location : CLLocation?
}

@objc class VehicalModel : NSObject {
    @objc static open var sharedInstance : VehicalModel = VehicalModel()
    @objc var locationStart : CLLocation
    @objc var locationEnd : CLLocation
    @objc var vehicals : [Vehical] = []

    private override init() {
        self.locationStart = CLLocation(latitude: 53.694865, longitude: 9.757589)
        self.locationEnd = CLLocation(latitude: 53.394655, longitude: 10.099891)
    }

    static func parseJSONToObject(json : Dictionary<String, Any>) {
        let poiList = json["poiList"] as! [[String : Any]]
        for dict in poiList {
            let vehicle = Vehical()
            vehicle.heading = dict["heading"] as? Double as NSNumber?
            vehicle.type = dict["type"] as? String
            vehicle.state = dict["state"] as? String
            vehicle.id = dict["id"] as? String
            if let locDict = dict["coordinate"] as? [String : Double] {
                let longitude = locDict["longitude"]
                let latitude = locDict["latitude"]
                vehicle.location = CLLocation(latitude: latitude!, longitude: longitude!)
            }
            self.sharedInstance.vehicals.append(vehicle)
        }
    }
}
