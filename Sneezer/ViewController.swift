//
//  ViewController.swift
//  Sneezer
//
//  Created by William Loftus on 3/24/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfectedViewControllerDelegate, SneezeEmitterDelegate, SneezeDetectorDelegate {

	var sneezeEmitter: SneezeEmitter?
	var sneezeDetector: SneezeDetector?

	required init(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
    }

	@IBOutlet var requestSneezeButton: UIButton!

	//MARK: View Lifecycle

	override func viewDidLoad() {

		super.viewDidLoad()

		// Be the Beacon
		self.sneezeEmitter = SneezeEmitter(delegate: self)
		
		// Hear the Beacon
		self.sneezeDetector = SneezeDetector(delegate: self)
	}

	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)
    }

	//MARK: User-Interaction
    @IBAction func sneezeButtonTapped() {

		self.requestSneezeButton.enabled = false

		self.sneezeEmitter?.sneezeContinuously()
    }

	@IBAction func infoButtonTapped() {
		
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
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func sneezeEmitterStoppedSneezing() {

		self.requestSneezeButton.enabled = true
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: Sneeze Detector Delegate
	
	func sneezeDetectorStartedListening() {

	}
	
	func sneezeDetectorHeardSneeze() {

		SoundEffectManager.sharedInstance.playSoundEffect(SoundEffectType.BlessYou)
		
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
