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

class ViewController: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {

	// Be the Beacon
	var beaconManager: CBPeripheralManager?
	var sneezingBeacons: [AnyObject]!

	// Hear the Beacon
	var locationManager: CLLocationManager?

	required init(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Listen for sneezing beacons
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self

		self.sneezingBeacons = [AnyObject]()
		let region: CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "5EC30DE0-4710-470F-A26C-A37FBCEFE1D4"), identifier: "com.SneezerApp")
	}

	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)

		// Broadcast sneezes
		self.beaconManager = CBPeripheralManager(delegate: self, queue: nil)
		self.beaconManager?.delegate = self
    }

	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
		
	}

	func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {

		self.sneezingBeacons = beacons

		for beacon: CLBeacon in self.sneezingBeacons as [CLBeacon]! {

			println("Found beacon with proximity \(beacon.proximity)")
		}

		if self.sneezingBeacons.count > 0 {
			// Play "Bless You"
			self.playSoundEffect("BlessYou")
		}
	}
	
    @IBAction func sneezeButtonTapped() {
        self.updateAdvertisedRegion()

		self.playSoundEffect("FactorySneeze")
    }
	
	func playSoundEffect(filename: String) {

		let path : NSString? = NSBundle.mainBundle().pathForResource(filename, ofType: "m4a")!
		let url = NSURL(fileURLWithPath: path!)
		
		var mySound: SystemSoundID = 0
		AudioServicesCreateSystemSoundID(url, &mySound)
		// Play
		AudioServicesPlaySystemSound(mySound)
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
