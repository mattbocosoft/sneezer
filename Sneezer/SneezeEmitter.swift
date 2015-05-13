//
//  SneezeEmitter.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

protocol SneezeEmitterDelegate {

	func sneezeEmitterStartedSneezing()
	func sneezeEmitterSneezingFailed(errorMessage: String)
	func sneezeEmitterStoppedSneezing()
}

class SneezeEmitter: NSObject, CBPeripheralManagerDelegate {

	var delegate: SneezeEmitterDelegate?

	private var beaconManager: CBPeripheralManager?
	private var continuousSneezing: Bool = false

	init(delegate: SneezeEmitterDelegate?) {

		super.init()

		self.delegate = delegate

		// Set-up sneeze emission
		self.beaconManager = CBPeripheralManager(delegate: self, queue: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "sneezeSoundEffectFinished", name: SoundEffectNotifications.SneezeDidFinish, object: nil)
	}

	//MARK: Sneeze Emission

	func sneezeOnce() {

		if self.beaconManager?.state != CBPeripheralManagerState.PoweredOn {
			
			self.delegate?.sneezeEmitterSneezingFailed("Bluetooth must be enabled to sneeze")
			return
			
		}

		if self.continuousSneezing == false {

			self.delegate?.sneezeEmitterStartedSneezing()
		}

		SoundEffectManager.sharedInstance.playSoundEffect(SoundEffectType.Sneeze)
	}

	func sneezeContinuously() {

		if self.beaconManager?.state != CBPeripheralManagerState.PoweredOn {
			
			self.delegate?.sneezeEmitterSneezingFailed("Bluetooth must be enabled to sneeze")
			return
			
		}

		self.delegate?.sneezeEmitterStartedSneezing()
		self.continuousSneezing = true
		self.sneezeOnce()
	}
	
	func stopContinuouslySneezing() {

		self.continuousSneezing = false
	}

	//MARK: Sound Effect Notification

	func sneezeSoundEffectFinished() {

		self.emitBeacon(duration: 1.0)
	}

	//MARK: -

	private func emitBeacon(#duration: NSTimeInterval) {
		
		self.beaconManager?.stopAdvertising()

		// We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
		var peripheralData: [NSObject : AnyObject]!
		
		let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "5EC30DE0-4710-470F-A26C-A37FBCEFE1D4"), major: 1, minor: 1, identifier: "com.SneezerApp")
		peripheralData = region.peripheralDataWithMeasuredPower(-59) as [NSObject : AnyObject]!
		
		// The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
		if peripheralData != nil {
			
			self.beaconManager?.startAdvertising(peripheralData)
		}

		if self.beaconManager == nil {

			self.delegate?.sneezeEmitterSneezingFailed("Could not initialize beacons")
		}

		// If duration is 0, then emit sneezing beacon indefinitely
		if duration > 0.0 {
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {

				self.stopBeacon()
			}
		}
	}
	
	private func stopBeacon() {
		
		self.beaconManager?.stopAdvertising()

		if self.continuousSneezing {
			
			let randomSneezeInterval: NSTimeInterval = 10
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(randomSneezeInterval * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				
				self.sneezeOnce()
			}
		} else {

			self.delegate?.sneezeEmitterStoppedSneezing()
		}
	}

	//MARK: CBPeripheralManager Delegate Functions
	
	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
		
	}

	//MARK: -
	deinit {

		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}
