//
//  VehicalDetailsViewController.swift
//  MyTeaxiExercise
//
//  Created by aathavale on 10/29/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

import UIKit

class VehicalDetailsViewController: UIViewController {

    @objc var vehical : Vehical?
    @IBOutlet var lblVehicalType: UILabel?
    @IBOutlet var lblVehicalState: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblVehicalType?.text = self.vehical?.type
        self.lblVehicalState?.text = self.vehical?.state
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
