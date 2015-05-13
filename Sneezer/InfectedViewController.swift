//
//  InfectedViewController.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class InfectedViewController: UIViewController {

	override func loadView() {

		self.view = SKView()
	}

    override func viewDidLoad() {

		super.viewDidLoad()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
