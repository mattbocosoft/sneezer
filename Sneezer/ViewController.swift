//
//  ViewController.swift
//  Sneezer
//
//  Created by William Loftus on 3/24/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController {

    var beaconManager: CBPeripheralManager?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

