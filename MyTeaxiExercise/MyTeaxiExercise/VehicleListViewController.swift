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
    var serviceLayer : ServiceLayer?
    
    var selectedIndex = -1;
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceLayer = ServiceLayer.sharedInstance
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Signup for service layer updates.
        //Calling in view will appear to make sure only active view controller can receive service layer updates.
        //This can change as per application requirements.
        serviceLayer?.delegate = self

        //Start download task here as this will be first view controller to display.
        serviceLayer?.getVehicalData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.vehicals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Return cell to display single item in the list. Using default cell as we have limited details.
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        let vehicle = self.model.vehicals[indexPath.row]
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = vehicle.type
        cell?.detailTextLabel?.text = vehicle.state
        cell?.imageView?.image = UIImage(named: "taxi_icon")
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Save selected index and show details view.
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowVehicalDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVehicalDetails" {
            //Provide data object to destination controller.
            if let destination = segue.destination as? VehicalDetailsViewController {
                destination.vehical = model.vehicals[selectedIndex]
            }
        }
    }

    // MARK :- ServiceLayerDelegates
    func receivedData() {
        //Data is received successfully. Update UI.
        self.tableView.reloadData()
    }

    func receivedError(_ error: Error?, response: URLResponse?) {
        let alert = UIAlertController(title: "Error!", message: "Something went wrong. Please try again in some time.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (void) in
            //We can call service again in case we need to try again.
        }))
        DispatchQueue.main.async {
            //Dispatching on main queue as error is received on background thread.
            self.present(alert, animated: true, completion: nil)
        }

        //Log error on console.
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
