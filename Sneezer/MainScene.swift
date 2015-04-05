//
//  MainScene.swift
//  Sneezer
//
//  Created by Matthew Thomas on 4/3/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

protocol NodeConstructor {
	var name: String { get }
	var imageName: String { get }
}

class Pathogen: NodeConstructor {
	var name: String { get { return "Pathogen" } }
	var imageName: String { get {
		let _imageName = "Pathogen\(arc4random_uniform(3) + 1).png"
		return _imageName
		}
	}
}

class MainScene: SKScene, SKPhysicsContactDelegate {

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
			self.generateBouncingNode(Pathogen())
		}

		self.physicsWorld.contactDelegate = self
	}

	func generateBouncingNode(category: NodeConstructor) {

		// 1
		let node = SKSpriteNode(imageNamed: category.imageName)
		node.size = CGSizeMake(100, 100)
		node.name = category.name
		node.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
		self.addChild(node)
		
		// 2
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width/3)
		// 3
		node.physicsBody?.friction = 0.0
		// 4
		node.physicsBody?.restitution = 1.0
		// 5
		node.physicsBody?.linearDamping = 0.0
		// 6
		node.physicsBody?.allowsRotation = true

		let maximumImpulse = UInt32(20)
		let xImpulse = CGFloat(arc4random_uniform(maximumImpulse))
		let yImpulse = CGFloat(arc4random_uniform(maximumImpulse))
		node.physicsBody?.applyImpulse(CGVectorMake(xImpulse, yImpulse))
		let angularImpulse = CGFloat(arc4random_uniform(5))/500.0
		node.physicsBody?.applyAngularImpulse(CGFloat(angularImpulse))

//		node.physicsBody?.categoryBitMask = category.name

		self.bouncingNodes?.append(node)
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		
	}
}
