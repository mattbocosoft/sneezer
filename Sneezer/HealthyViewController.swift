//
//  HealthyViewController.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

protocol HealthyViewControllerDelegate {

	func healthyViewControllerAllAngelsPoofed()
}

class HealthyViewController: UIViewController {

	var delegate: HealthyViewControllerDelegate?

	private var angelScene: AngelScene?

	//MARK: View Lifecycle

	override func loadView() {
		
		self.view = SKView()
	}

	override func viewDidLoad() {

		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "sneezeDetected", name: SneezeDetectionNotifications.SneezeDetected, object: nil)
    }

	override func viewWillLayoutSubviews() {
		
		super.viewWillLayoutSubviews()
		
		let skView = self.view as! SKView
		
		if skView.scene == nil {
			
			skView.showsFPS = false
			skView.showsNodeCount = false
			
			// Create and configure the scene.
			self.angelScene = AngelScene(size: skView.bounds.size)
			self.angelScene?.scaleMode = SKSceneScaleMode.AspectFill
			
			// Present the scene.
			skView.presentScene(self.angelScene)
		}
	}

	//MARK: Sneeze Detection
	
	func sneezeDetected() {

		let soundEffectAction = SKAction.playSoundFileNamed("BlessYou.m4a", waitForCompletion: true)
		self.angelScene?.runAction(soundEffectAction)

		self.angelScene?.removeAngel(completion: { () -> Void in

			if let angelScene = self.angelScene {
				
				if angelScene.angelCount() == 0 {
					
					self.delegate?.healthyViewControllerAllAngelsPoofed()
				}
			}
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {

		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}
