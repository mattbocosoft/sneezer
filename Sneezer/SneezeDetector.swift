//
//  SneezeDetector.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

protocol SneezeDetectorDelegate {

	func sneezeDetectorStartedListening()
	func sneezeDetectorHeardSneeze()
}

class SneezeDetector: NSObject, CLLocationManagerDelegate {

	var delegate: SneezeDetectorDelegate?

	private var locationManager: CLLocationManager?
	private var listenForSneezeRegion: CLBeaconRegion?

	init(delegate: SneezeDetectorDelegate?) {

		super.init()

		self.delegate = delegate

		// Set-up sneezing detector
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self

		if !CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
			
			UIAlertView(title: "Unavailable", message: "Beacon region monitoring is not available on this device.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
			return
		}
		
		if !CLLocationManager.isRangingAvailable() {
			
			UIAlertView(title: "Unavailable", message: "Beacon ranging is not available on this device.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
			return
		}
		
		self.listenForSneezeRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "5EC30DE0-4710-470F-A26C-A37FBCEFE1D4"), identifier: "com.SneezerApp")

		let authorizationStatus = CLLocationManager.authorizationStatus()
		if authorizationStatus == CLAuthorizationStatus.AuthorizedAlways || authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {
			
			self.startListeningForSneezes()
			
		} else {
			
			UIAlertView(title: "Unavailable", message: "Location monitoring has not authorized.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
			self.locationManager?.requestAlwaysAuthorization()
		}
	}

	//MARK: Sneeze Detection
	func startListeningForSneezes() {
		
		if let listenForSneezeRegion = self.listenForSneezeRegion {

			self.locationManager?.startRangingBeaconsInRegion(listenForSneezeRegion)
			self.delegate?.sneezeDetectorStartedListening()
		}
	}
	
	private func sneezeDetected(proximity: CLProximity) {
		
		if !Blessings.enabled {
			return
		}
		
		if Blessings.hasRecentlyIssuedBlessing {
			
			return
		}
		
		Blessings.hasRecentlyIssuedBlessing = true
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Blessings.blessYouTimeInvervalTheshold * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { Blessings.hasRecentlyIssuedBlessing = false }
		
		// Play "Bless You"
		let probability = CGFloat(arc4random_uniform(100) + 1) / 100.0
		
		
		if proximity == CLProximity.Far {
			println(" You're far away from the sneezer")
			if probability <= 0.10 {
				println(probability, "You caught the cold!")
			}
		} else if proximity == CLProximity.Near {
			println(" You're near the sneezer")
			if probability <= 0.50 {
				println(probability, "You caught the cold!")
			}
		} else if proximity == CLProximity.Immediate {
			println(" You're right next to the sneezer")
			if probability <= 0.75 {
				println(probability, "You caught the cold!")
			}
		} else {
			println( "Proximity Unknown")
		}

		self.delegate?.sneezeDetectorHeardSneeze()
	}
	
	//MARK: CLLocationManager Delegate Functions
	
	
	func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
		
		for beacon: CLBeacon in (beacons as! [CLBeacon]) {
			
			println("Found beacon with proximity \(beacon.proximity)")
		}
		
		if beacons.count > 0 {
			
			if beacons.first?.proximity != CLProximity.Unknown {
				self.sneezeDetected(beacons.first!.proximity)
			}
			
		}
	}
	
	func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
		
		UIAlertView(title: "Error", message: "Ranging beacons failed.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
		return
	}
	
	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		
		if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways {
			
			self.startListeningForSneezes()
		}
	}
}
