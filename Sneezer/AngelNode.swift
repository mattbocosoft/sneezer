//
//  AngelNode.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class AngelNode: SKSpriteNode {

	init() {

		let name = "Angel"

		let texture = SKTexture(imageNamed: "\(name).png")
		super.init(texture: texture, color: nil, size: texture.size())

		self.size = CGSizeMake(150, 150)
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
