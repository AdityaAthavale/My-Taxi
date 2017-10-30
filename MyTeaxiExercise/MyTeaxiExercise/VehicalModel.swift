//
//  VehicalModel.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/27/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import Foundation
import CoreLocation

//Creating Data Class For Vehicals.
@objc class Vehical : NSObject {
    @objc var type : String?
    @objc var state : String?
    @objc var id: String?
    @objc var heading : NSNumber?
    @objc var location : CLLocation?
}

//Creating Data Model to save state of application.
@objc class VehicalModel : NSObject {
    //Creating shared instance of the Model to make it singleton.
    //This will ensure all classes in application are forced to use single object of model and maintain data integrity.
    @objc static open var sharedInstance : VehicalModel = VehicalModel()
    @objc var locationStart : CLLocation
    @objc var locationEnd : CLLocation
    @objc var locationCenter : CLLocation

    @objc var vehicals : [Vehical] = []

    //Making the constructor private to achive singleton implementation.
    private override init() {
        self.locationStart = CLLocation(latitude: 53.694865, longitude: 9.757589)
        self.locationEnd = CLLocation(latitude: 53.394655, longitude: 10.099891)

        //Averaging locations to get center.
        self.locationCenter = CLLocation(latitude: 53.54476, longitude: 9.92874)
        super.init()
    }

    //After Model receives the data it should modify and save it.
    func parseJSONToObject(json : Dictionary<String, Any>) {
        self.vehicals = []
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
            self.vehicals.append(vehicle)
        }
    }
}
