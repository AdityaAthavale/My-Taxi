//
//  ServiceLayer.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/29/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import UIKit
import CoreLocation

//Protocol to let other objects know about updates from service layer.
@objc protocol ServiceLayerDelegate {
    @objc func receivedData()
    @objc func receivedError(_ error: Error?, response : URLResponse?)
}

//Creating service layer to isolate all network traffic from application logic.
@objc class ServiceLayer: NSObject {

    //Ensuring all classes in application use single service layer
    @objc static var sharedInstance : ServiceLayer = ServiceLayer()
    
    //Delegate to provide update.
    @objc var delegate : ServiceLayerDelegate?

    private override init() {
        super.init()
    }

    @objc func getVehicalData() {
        //Creating URL session
        let session = URLSession(configuration: URLSessionConfiguration.default)

        //Hardcoding URL for demo purpose. This will be generated dynamically in realtime application.
        let url : URL = URL(string : "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891")!

        //Creating data task to download data.
        session.dataTask(with: url, completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            if error != nil {
                //If something goes wrong, update delegate and return. No Need tp process anything.
                self.delegate?.receivedError(error, response: response)
                return
            }
            //If it comes to this line we do not have error.
            if let jsonData = data { //Check if data is nil.
                do {
                    //Try and serialize JSON and parse it.
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                    VehicalModel.sharedInstance.parseJSONToObject(json: json!)
                    DispatchQueue.main.async {
                        //Dispatching on main queue so that UI can be updated accordingly.
                        self.delegate?.receivedData()
                    }
                }
                catch {
                    //Error may be dispathed on Background queue. Let programmer decide if they want to provide visual feedback or not.
                    self.delegate?.receivedError(error, response: response)
                }
            } else {
                self.delegate?.receivedError(error, response: response)
            }
        }).resume() //Start download.
    }
}
