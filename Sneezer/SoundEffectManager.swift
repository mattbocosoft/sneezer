//
//  SoundEffectManager.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

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

struct SoundEffectNotifications {

	static let BlessingDidFinish = "SoundEffectNotifications.BlessingDidFinish"
	static let SneezeDidFinish = "SoundEffectNotifications.SneezeDidFinish"
}

class SoundEffectManager: NSObject, AVAudioPlayerDelegate {

	static let sharedInstance = SoundEffectManager()

	var blessYouAudioPlayer: AVAudioPlayer?
	var sneezeAudioPlayer: AVAudioPlayer?
	
	override init() {

		var error: NSError?
		AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: &error)
		AVAudioSession.sharedInstance().setActive(true, error: &error)

		super.init()

		self.loadBlessYouAudioPlayer()
		self.loadSneezeAudioPlayer()
	}
	
	private func loadBlessYouAudioPlayer() {

		let path: NSString? = NSBundle.mainBundle().pathForResource(SoundEffectType.BlessYou.description, ofType: "m4a")!
		let url = NSURL(fileURLWithPath: path! as String)
		
		var error:NSError?
		self.blessYouAudioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
		if error != nil {
			println("Error creating sound effect \(error?.localizedDescription)")
			return
		}
		self.blessYouAudioPlayer?.delegate = self
		self.blessYouAudioPlayer?.prepareToPlay()
	}

	private func loadSneezeAudioPlayer() {
		
		let path: NSString? = NSBundle.mainBundle().pathForResource(SoundEffectType.Sneeze.description, ofType: "m4a")!
		let url = NSURL(fileURLWithPath: path! as String)
		
		var error:NSError?
		self.sneezeAudioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
		if error != nil {
			println("Error creating sound effect \(error?.localizedDescription)")
			return
		}
		self.sneezeAudioPlayer?.delegate = self
		self.sneezeAudioPlayer?.prepareToPlay()
	}

	func playSoundEffect(type: SoundEffectType) {

		switch type {
		case .BlessYou:
			self.blessYouAudioPlayer?.play()
			break
		case .Sneeze:
			self.sneezeAudioPlayer?.play()
			break
		default:
			break
		}
	}

	//MARK: AVAudioPlayer Delegate

	func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
		
//		Blessings.enabled = true
		
		if player == self.sneezeAudioPlayer {

			NSNotificationCenter.defaultCenter().postNotificationName(SoundEffectNotifications.SneezeDidFinish, object: self)
			self.sneezeAudioPlayer?.prepareToPlay()

		} else if player == self.blessYouAudioPlayer {

			NSNotificationCenter.defaultCenter().postNotificationName(SoundEffectNotifications.BlessingDidFinish, object: self)
			self.blessYouAudioPlayer?.prepareToPlay()
		}
	}
}
