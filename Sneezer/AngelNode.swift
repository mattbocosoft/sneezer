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
		super.init(texture: texture, color: nil, size: CGSizeMake(100, 100))

		self.name = name

		self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/3)
		self.physicsBody?.friction = 0.0
		self.physicsBody?.restitution = 1.0
		self.physicsBody?.linearDamping = 0.0
	}

	func poof() {

		let cloudName = "CloudExplosion"
		let cloudNode = SKSpriteNode(imageNamed: "\(cloudName).png")

		cloudNode.size = self.size
		cloudNode.name = name
		cloudNode.alpha = 0.0
		self.addChild(cloudNode)

		let inDuration = 0.2
		let outDuration = 1.0

		let cloudMaximumScale = CGFloat(1.5)

		let inGroup = SKAction.group([SKAction.fadeInWithDuration(inDuration), SKAction.scaleTo(cloudMaximumScale, duration: inDuration)])
		cloudNode.runAction(inGroup, completion: { () -> Void in

			cloudNode.removeFromParent()
			self.texture = SKTexture(imageNamed: "\(cloudName).png")
			self.setScale(cloudMaximumScale)

			let fadeOutAction = SKAction.fadeOutWithDuration(outDuration)
			let scaleDownAction = SKAction.scaleTo(0.8, duration: outDuration)
			let outGroup = SKAction.group([fadeOutAction, scaleDownAction])

			self.runAction(outGroup, completion: { () -> Void in
				self.removeFromParent()
			})
		})
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
