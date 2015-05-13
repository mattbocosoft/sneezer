//
//  ViewController.swift
//  Sneezer
//
//  Created by William Loftus on 3/24/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
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

class ViewController: UIViewController, AVAudioPlayerDelegate, InfectedViewControllerDelegate, SneezeEmitterDelegate, SneezeDetectorDelegate {

	var audioPlayer: AVAudioPlayer?

	var sneezeEmitter: SneezeEmitter?
	var sneezeDetector: SneezeDetector?

	required init(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
    }

	@IBOutlet var requestSneezeButton: UIButton!

	//MARK: View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)

		// Be the Beacon
		self.sneezeEmitter = SneezeEmitter()
		self.sneezeEmitter?.delegate = self

		// Hear the Beacon
		self.sneezeDetector = SneezeDetector()
		self.sneezeDetector?.delegate = self
		self.sneezeDetector?.startListeningForSneezes()
    }

	override func viewWillLayoutSubviews() {

		super.viewWillLayoutSubviews()
	}

	//MARK: User-Interaction
    @IBAction func sneezeButtonTapped() {

		self.playSoundEffect(SoundEffectType.Sneeze)
    }

	@IBAction func infoButtonTapped() {
		
	}

	//MARK: Helper Functions

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

		Blessings.enabled = false

		if self.audioPlayer?.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.Sneeze.description {

			self.requestSneezeButton.enabled = false
		}
	}

	//MARK: AVAudioPlayer Delegate

	func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {

		Blessings.enabled = true

		if player.url.lastPathComponent?.stringByDeletingPathExtension == SoundEffectType.Sneeze.description {

			self.sneezeEmitter?.emitSneezingBeacon(1.0)
		}
	}

	//MARK: Sneeze Emitter Delegate
	
	func sneezeEmitterStartedSneezing() {
		
		self.showInfectedView()
	}
	
	func sneezeEmitterSneezingFailed(errorMessage: String) {

		let title = "Error"
		let cancelButtonTitle = "OK"
		UIAlertView(title: title, message: errorMessage, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: cancelButtonTitle).show()

		self.requestSneezeButton.enabled = true
	}
	
	func sneezeEmitterStoppedSneezing() {
		
		self.requestSneezeButton.enabled = true
	}
	
	//MARK: Sneeze Detector Delegate
	
	func sneezeDetectorStartedListening() {

	}
	
	func sneezeDetectorHeardSneeze() {
		
		self.playSoundEffect(SoundEffectType.BlessYou)
		
		//TODO: Show infected/healthy view depending on whether the user has been infected
		self.showHealthyView()
	}

	//MARK: Modal Views

	func showHealthyView() {

		let viewController = HealthyViewController()
		viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(viewController, animated: true, completion: nil)
	}

	func showInfectedView() {
		
		let viewController = InfectedViewController()
		viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(viewController, animated: true, completion: nil)
	}
	
	//MARK: Infected View Controller Delegate
	
	func infectedViewControllerCompleted() {

		self.dismissViewControllerAnimated(true, completion: nil)
	}

	//MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
