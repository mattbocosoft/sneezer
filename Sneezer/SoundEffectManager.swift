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

	var audioPlayer: AVAudioPlayer?

	func playSoundEffect(type: SoundEffectType) {
		
		let path: NSString? = NSBundle.mainBundle().pathForResource(type.description, ofType: "m4a")!
		let url = NSURL(fileURLWithPath: path! as String)
		
		var error:NSError?
		self.audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
		if error != nil {
			println("Error creating sound effect \(error?.localizedDescription)")
			return
		}
		self.audioPlayer?.delegate = self
		self.audioPlayer?.play()
	}

	//MARK: AVAudioPlayer Delegate

	func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
		
//		Blessings.enabled = true
		
		if player.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.Sneeze.description {

			NSNotificationCenter.defaultCenter().postNotificationName(SoundEffectNotifications.SneezeDidFinish, object: self)

		} else if player.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.BlessYou.description {
			
			NSNotificationCenter.defaultCenter().postNotificationName(SoundEffectNotifications.BlessingDidFinish, object: self)
		}
	}
}
