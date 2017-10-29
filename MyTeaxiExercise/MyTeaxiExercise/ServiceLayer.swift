//
//  ServiceLayer.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/29/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol ServiceLayerDelegate {
    @objc func receivedData()
    @objc func receivedError(_ error: Error?, response : URLResponse?)
}

class ServiceLayer: NSObject {

    var delegate : ServiceLayerDelegate?
    func getVehicalData() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url : URL = URL(string : "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891")!
        session.dataTask(with: url, completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            if let jsonData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                    VehicalModel.parseJSONToObject(json: json!)
                    DispatchQueue.main.async {
                        self.delegate?.receivedData()
                    }
                }
                catch {
                    self.delegate?.receivedError(error, response: response)
                }
            } else {
                self.delegate?.receivedError(error, response: response)
            }
        }).resume()
    }
}
