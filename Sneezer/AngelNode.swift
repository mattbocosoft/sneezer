//
//  AngelNode.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class AngelNode: SKNode {

	private var angelSpriteNode: SKSpriteNode?
	private var cloudSpriteNode: SKSpriteNode?

	override init() {

		super.init()

		let name = "Angel"
		self.name = name

		self.angelSpriteNode = SKSpriteNode(imageNamed: "\(name).png")
		self.angelSpriteNode?.size = CGSizeMake(150, 150)
		self.addChild(self.angelSpriteNode!)

		self.angelSpriteNode?.physicsBody = SKPhysicsBody(circleOfRadius: self.angelSpriteNode!.frame.size.width/3)
		self.angelSpriteNode?.physicsBody?.friction = 0.0
		self.angelSpriteNode?.physicsBody?.restitution = 1.0
		self.angelSpriteNode?.physicsBody?.linearDamping = 0.0
	}

	func poof() {
		
		let name = "CloudExplosion"
		
		let cloudNode = SKSpriteNode(imageNamed: "\(name).png")
		cloudNode.size = CGSizeMake(150, 150)
		cloudNode.name = name
		cloudNode.alpha = 0.0
		self.addChild(cloudNode)

		let inDuration = 0.2
		let outDuration = 1.0

		// Angel Fade
		self.angelSpriteNode?.runAction(SKAction.fadeOutWithDuration(inDuration))

		// Cloud Fade Sequence
		let fadeInAction = SKAction.fadeInWithDuration(inDuration)
		let fadeOutAction = SKAction.fadeOutWithDuration(outDuration)
		
		let fadeSequence = SKAction.sequence([fadeInAction, fadeOutAction])
		cloudNode.runAction(fadeSequence)

		// Cloud Scale Sequence
		let scaleUpAction = SKAction.scaleBy(1.5, duration: inDuration)
		let scaleDownAction = SKAction.scaleBy(0.8, duration: outDuration)
		
		let scaleSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
		cloudNode.runAction(scaleSequence)

		self.cloudSpriteNode = cloudNode
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
