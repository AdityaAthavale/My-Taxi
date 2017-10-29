//
//  VehicleListViewController.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/27/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import UIKit
import CoreLocation

class VehicleListViewController: UITableViewController, ServiceLayerDelegate {

    var model : VehicalModel = VehicalModel.sharedInstance
    let serviceLayer : ServiceLayer = ServiceLayer()
    var selectedIndex = -1;
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceLayer.delegate = self
        serviceLayer.getVehicalData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.vehicals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        let vehicle = self.model.vehicals[indexPath.row]
        cell?.textLabel?.text = vehicle.type
        cell?.detailTextLabel?.text = vehicle.state
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowVehicalDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVehicalDetails" {
            if let destination = segue.destination as? VehicalDetailsViewController {
                destination.vehical = model.vehicals[selectedIndex]
            }
        }
    }

    // MARK :- ServiceLayerDelegates
    func receivedData() {
        self.tableView.reloadData()
    }

    func receivedError(_ error: Error?, response: URLResponse?) {
        print("\(error!)")
        print("\(response!)")
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
