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
import AudioToolbox


class ViewController: UIViewController, CBPeripheralManagerDelegate {

    var beaconManager: CBPeripheralManager?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
	
	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)

		if self.beaconManager == nil {

			self.beaconManager = CBPeripheralManager(delegate: self, queue: nil)
		}
		else
		{
			self.beaconManager?.delegate = self
		}
    }
    
    @IBAction func sneezeButtonTapped() {
        self.updateAdvertisedRegion()
        let path : NSString? = NSBundle.mainBundle().pathForResource("FactorySneeze", ofType: "m4a")!
        let url = NSURL(fileURLWithPath: path!)
 
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url, &mySound)
        // Play
        AudioServicesPlaySystemSound(mySound)
        
    }
	
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {

	}
	
	func updateAdvertisedRegion() {

		if self.beaconManager?.state != CBPeripheralManagerState.PoweredOn {
			
			let title = "Bluetooth must be enabled"
			let message = "To configure your device as a beacon"
			let cancelButtonTitle = "OK"
			UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: cancelButtonTitle).show()
			return
		}
		
		self.beaconManager?.stopAdvertising()
		
		// We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
		var peripheralData: NSDictionary?
	
		let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "5EC30DE0-4710-470F-A26C-A37FBCEFE1D4"), major: 1, minor: 1, identifier: "com.SneezerApp")
		peripheralData = region.peripheralDataWithMeasuredPower(-59)
	
		// The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
		if peripheralData != nil {

			self.beaconManager?.startAdvertising(peripheralData)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
