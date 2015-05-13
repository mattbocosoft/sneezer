//
//  BouncingScene.swift
//  Sneezer
//
//  Created by Matthew Thomas on 4/3/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class BouncingScene: SKScene, SKPhysicsContactDelegate {

	private var bouncingNodes: [SKSpriteNode]?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(size: CGSize) {
		super.init(size: size)

		let backgroundNode = SKSpriteNode(imageNamed: "Background.png")
		backgroundNode.size = self.frame.size
		backgroundNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
		self.addChild(backgroundNode)
		
		self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)

		// 1 Create an physics body that borders the screen
		let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
		// 2 Set physicsBody of scene to borderBody
		self.physicsBody = borderBody
		// 3 Set the friction of that physicsBody to 0
		self.physicsBody?.friction = 0.0

		self.bouncingNodes = [SKSpriteNode]()

		for i in 0...5 {
			self.addBouncingNode(self.generatePathogenNode())
		}

		self.physicsWorld.contactDelegate = self
	}

	func generateAngelNode() -> SKSpriteNode {

		let name = "Angel"

		let node = SKSpriteNode(imageNamed: "\(name)\(arc4random_uniform(2) + 1).png")
		node.size = CGSizeMake(150, 150)
		node.name = name
		node.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);

//		node.physicsBody?.categoryBitMask = category.name

		return node
	}

	func generatePathogenNode() -> SKSpriteNode {
		
		let name = "Pathogen"
		
		let node = SKSpriteNode(imageNamed: "\(name)\(arc4random_uniform(3) + 1).png")
		node.size = CGSizeMake(100, 100)
		node.name = name
		node.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
		
//		node.physicsBody?.categoryBitMask = category.name
		
		return node
	}

	func addBouncingNode(node: SKSpriteNode) {

		self.addChild(node)
	
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width/3)
		node.physicsBody?.friction = 0.0
		node.physicsBody?.restitution = 1.0
		node.physicsBody?.linearDamping = 0.0
		node.physicsBody?.allowsRotation = true

		let maximumImpulse = UInt32(40)
		let xImpulse = CGFloat(arc4random_uniform(maximumImpulse)) - CGFloat(maximumImpulse)/2.0
		let yImpulse = CGFloat(arc4random_uniform(maximumImpulse)) - CGFloat(maximumImpulse)/2.0
		node.physicsBody?.applyImpulse(CGVectorMake(xImpulse, yImpulse))
		let angularImpulse = CGFloat(arc4random_uniform(5))/500.0
		node.physicsBody?.applyAngularImpulse(CGFloat(angularImpulse))

		self.bouncingNodes?.append(node)
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		
	}
}
