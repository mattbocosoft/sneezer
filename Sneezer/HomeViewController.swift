//
//  HomeViewController.swift
//  Sneezer
//
//  Created by William Loftus on 3/24/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit

struct Blessings {

	static var enabled = true
}

class HomeViewController: UIViewController, HealthyViewControllerDelegate, InfectedViewControllerDelegate, SneezeDetectorDelegate {

	var sneezeDetector: SneezeDetector?

	required init(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
    }

	@IBOutlet var requestSneezeButton: UIButton!

	//MARK: View Lifecycle

	override func viewDidLoad() {

		super.viewDidLoad()
		
		// Hear the Beacon
		self.sneezeDetector = SneezeDetector(delegate: self)
	}

	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)
    }

	//MARK: User-Interaction
    @IBAction func sneezeButtonTapped() {

		self.requestSneezeButton.enabled = false
		self.showInfectedView()
    }

	@IBAction func infoButtonTapped() {

	}

	//MARK: Sneeze Detector Delegate

	func sneezeDetectorStartedListening() {

	}

	func sneezeDetectorHeardSneeze() {

		if !Blessings.enabled {
			return
		}
		
		Blessings.enabled = false

		// There is already a presented view controller
		if self.presentedViewController != nil {
			return
		}

		//TODO: Show infected/healthy view depending on whether the user has been infected
		self.showHealthyView()
	}

	//MARK: Modal Views

	func showHealthyView() {

		let viewController = HealthyViewController()
		viewController.delegate = self
		viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(viewController, animated: true, completion: nil)
	}

	func showInfectedView() {
		
		let viewController = InfectedViewController()
		viewController.delegate = self
		viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(viewController, animated: true, completion: nil)
	}

	//MARK: Healthy View Controller Delegate
	
	func healthyViewControllerAllAngelsPoofed() {

		self.dismissViewControllerAnimated(true, completion: { () -> Void in

			self.showInfectedView()
		})
	}
	//MARK: Infected View Controller Delegate
	
	func infectedViewControllerCompleted() {

		self.dismissViewControllerAnimated(true, completion: { () -> Void in
			self.requestSneezeButton.enabled = true
		})
	}

	//MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
