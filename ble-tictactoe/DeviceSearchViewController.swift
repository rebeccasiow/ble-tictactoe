//
//  DeviceSearchViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/1/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit
import CoreBluetooth

var currentDeviceScanPeripheral = DeviceScanPeripheral()


class DeviceSearchViewController: UIViewController {

    
    
    override func viewDidLoad() {
        print("DeviceScan")
        super.viewDidLoad()
        currentDeviceScanPeripheral = DeviceScanPeripheral()


        // Do any additional setup after loading the view.
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
