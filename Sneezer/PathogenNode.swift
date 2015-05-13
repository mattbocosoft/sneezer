//
//  PathogenNode.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class PathogenNode: SKSpriteNode {

	init() {

		let name = "Pathogen"
		
		let texture = SKTexture(imageNamed: "\(name)\(arc4random_uniform(3) + 1).png")
		super.init(texture: texture, color: nil, size: texture.size())
		
		self.size = CGSizeMake(100, 100)
		self.name = name
		
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/3)
		self.physicsBody?.friction = 0.0
		self.physicsBody?.restitution = 1.0
		self.physicsBody?.linearDamping = 0.0
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
