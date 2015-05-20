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

		self.sneezeEmitter?.sneezeContinuously()
	}

	override func viewWillLayoutSubviews() {

		super.viewWillLayoutSubviews()
		
		let skView = self.view as! SKView
		
		if skView.scene == nil {
			
			skView.showsFPS = false
			skView.showsNodeCount = false
			
			// Create and configure the scene.
			let scene = PathogenScene(size: skView.bounds.size)
			scene.scaleMode = SKSceneScaleMode.AspectFill
			
			// Present the scene.
			skView.presentScene(scene)
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

	//MARK: Sneeze Emitter Delegate
	
	func sneezeEmitterStartedSneezing() {

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
