//
//  InfectedViewController.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

protocol InfectedViewControllerDelegate {
	func infectedViewControllerCompleted()
}

class InfectedViewController: UIViewController, SneezeEmitterDelegate {

	var sneezeEmitter: SneezeEmitter?
	var delegate: InfectedViewControllerDelegate?

	private var pathogenScene: PathogenScene?
	private var continuousSneezing: Bool = false

	//MARK: View Lifecycle
	override func loadView() {

		self.view = SKView()
	}

    override func viewDidLoad() {

		super.viewDidLoad()

		// Be the Beacon
		self.sneezeEmitter = SneezeEmitter(delegate: self)
    }
	
	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)

		self.sneezeContinuously()
	}

	override func viewWillLayoutSubviews() {

		super.viewWillLayoutSubviews()
		
		let skView = self.view as! SKView
		
		if skView.scene == nil {
			
			skView.showsFPS = false
			skView.showsNodeCount = false
			
			// Create and configure the scene.
			self.pathogenScene = PathogenScene(size: skView.bounds.size)
			self.pathogenScene?.scaleMode = SKSceneScaleMode.AspectFill
			
			// Present the scene.
			skView.presentScene(self.pathogenScene)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: User Interaction

	@IBAction func userTappedClose() {

		self.delegate?.infectedViewControllerCompleted()
	}
	
	//MARK: Continuous sneezing

	func sneezeContinuously() {
		
		// Already sneezing
		if self.continuousSneezing {
			return
		}

		self.continuousSneezing = true
		self.playSneezeSoundEffect { () -> Void in
			self.sneezeEmitter?.sneezeOnce()
		}
	}
	
	func playSneezeSoundEffect(completion block: (() -> Void)!) {

		let soundEffectAction = SKAction.playSoundFileNamed("FactorySneeze.m4a", waitForCompletion: true)
		self.pathogenScene?.runAction(soundEffectAction, completion: block)
	}

	func stopContinuouslySneezing() {

		self.continuousSneezing = false
	}

	//MARK: Sneeze Emitter Delegate

	func sneezeEmitterWillSneeze() {
		
	}

	func sneezeEmitterDidSneeze() {

		if self.continuousSneezing {
			
			let randomSneezeInterval: NSTimeInterval = 10
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(randomSneezeInterval * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				
				self.playSneezeSoundEffect { () -> Void in
					self.sneezeEmitter?.sneezeOnce()
				}
			}
		}
	}
	
	func sneezeEmitterSneezingFailed(errorMessage: String) {
		
		let title = "Error"
		let cancelButtonTitle = "OK"
		UIAlertView(title: title, message: errorMessage, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: cancelButtonTitle).show()

		self.delegate?.infectedViewControllerCompleted()
	}

	func sneezeEmitterStoppedSneezing() {

		self.delegate?.infectedViewControllerCompleted()
	}
}
