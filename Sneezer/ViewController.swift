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
import AVFoundation
import SpriteKit

enum SoundEffectType {
	
	case Sneeze
	case BlessYou
	
	var description : String {
		switch self {
		case .Sneeze: return "FactorySneeze"
		case .BlessYou: return "BlessYou"
		}
	}
}

struct Blessings {
	static var blessYouTimeInvervalTheshold: NSTimeInterval = 3.0 // Minimum amount of time before saying "Bless You" again
	static var hasRecentlyIssuedBlessing = false
	static var enabled = true
}

class ViewController: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate {

	// Be the Beacon
	var beaconManager: CBPeripheralManager?

	// Hear the Beacon
	var locationManager: CLLocationManager?
	var listenForSneezeRegion: CLBeaconRegion?

	var audioPlayer: AVAudioPlayer?

	required init(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
    }

	@IBOutlet var requestSneezeButton: UIButton!

	//MARK: View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		// Set-up sneeze emission
		self.beaconManager = CBPeripheralManager(delegate: self, queue: nil)
		self.beaconManager?.delegate = self

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
	}

	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)

		let authorizationStatus = CLLocationManager.authorizationStatus()
		if authorizationStatus == CLAuthorizationStatus.AuthorizedAlways || authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse {

			self.startListeningForSneezes()

		} else {

			UIAlertView(title: "Unavailable", message: "Location monitoring has not authorized.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
			self.locationManager?.requestAlwaysAuthorization()
		}
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		let skView = self.view as SKView

		if skView.scene == nil {

			skView.showsFPS = false
			skView.showsNodeCount = false
			
			// Create and configure the scene.
			let scene = BouncingScene(size: skView.bounds.size)
			scene.scaleMode = SKSceneScaleMode.AspectFill

			// Present the scene.
			skView.presentScene(scene)
		}
	}

	//MARK: CBPeripheralManager Delegate Functions

	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
		
	}

	//MARK: CLLocationManager Delegate Functions

	func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {

		for beacon: CLBeacon in beacons {

			println("Found beacon with proximity \(beacon.proximity)")
		}

		if beacons.count > 0 {
            if beacons.first?.proximity != CLProximity.Unknown {
                self.sneezeDetected()
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

	//MARK: User-Interaction
    @IBAction func sneezeButtonTapped() {

		self.playSoundEffect(SoundEffectType.Sneeze)
    }

	//MARK: Sneeze Emission
	func emitSneezingBeacon(duration: NSTimeInterval) {

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

		// If duration is 0, then emit sneezing beacon indefinitely
		if duration > 0.0 {
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) { self.stopSneezingBeacon() }
		}
	}

	func stopSneezingBeacon() {

		self.beaconManager?.stopAdvertising()
		self.requestSneezeButton.enabled = true
	}

	//MARK: Sneeze Detection
	func startListeningForSneezes() {

		if let listenForSneezeRegion = self.listenForSneezeRegion {
			self.locationManager?.startRangingBeaconsInRegion(listenForSneezeRegion)
		}
	}
	
	func sneezeDetected() {

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
		self.playSoundEffect(SoundEffectType.BlessYou)
	}

	//MARK: Helper Functions
	func playSoundEffect(type: SoundEffectType) {

		let path: NSString? = NSBundle.mainBundle().pathForResource(type.description, ofType: "m4a")!
		let url = NSURL(fileURLWithPath: path!)

		var error:NSError?
		self.audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
		if error != nil {
			println("Error creating sound effect \(error?.localizedDescription)")
			return
		}
		self.audioPlayer?.delegate = self
		self.audioPlayer?.play()

		Blessings.enabled = false

		if self.audioPlayer?.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.Sneeze.description {

			self.requestSneezeButton.enabled = false
			
		}
	}
	
	func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {

		Blessings.enabled = true

		if player.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.Sneeze.description {

			self.emitSneezingBeacon(1.0)

		}
	}

	//MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
