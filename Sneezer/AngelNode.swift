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

	private let angelTexture = SKTexture(imageNamed: "Angel.png")
	private var flyingFrames = [SKTexture]()
	private let cloudTexture = SKTexture(imageNamed: "CloudExplosion.png")

	private var cloudNode: SKSpriteNode!

	init() {

		let name = "Angel"
		let textureSize = CGSizeMake(100, 100)

		super.init(texture: angelTexture, color: nil, size: textureSize)

		// Set-up flying animation
		let animationImageCount = 10
		for index in 1...animationImageCount {

			let textureName = "angel_animation\(index).png"
			self.flyingFrames.append(SKTexture(imageNamed: textureName))
		}
		for index in 0..<animationImageCount {
			
			let textureName = "angel_animation\(animationImageCount - index).png"
			self.flyingFrames.append(SKTexture(imageNamed: textureName))
		}

		self.name = name
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.size.width/3)
		self.physicsBody?.friction = 0.0
		self.physicsBody?.restitution = 1.0
		self.physicsBody?.linearDamping = 0.0
		self.physicsBody?.allowsRotation = false

		SKTexture.preloadTextures([self.angelTexture, self.cloudTexture], withCompletionHandler: { () -> Void in
		})

		let cloudName = "CloudExplosion"
		self.cloudNode = SKSpriteNode(texture: self.cloudTexture, size: self.size)
		self.cloudNode.name = name
		self.cloudNode.alpha = 0.0
	}
	
	func startFlying() {

		let animationAction = SKAction.animateWithTextures(self.flyingFrames, timePerFrame: 0.05)
		self.runAction(SKAction.repeatActionForever(animationAction), withKey: "flyingAngel")
	}
	
	func travelLeft() {

		if self.xScale != -1.0 {
			self.runAction(SKAction.scaleXTo(-1.0, duration: 0.05))
		}
	}
	
	func travelRight() {

		if self.xScale != 1.0 {
			self.runAction(SKAction.scaleXTo(1.0, duration: 0.05))
		}
	}

	func poof(completion block: (() -> Void)!) {

		self.addChild(self.cloudNode)

		let inDuration = 0.2
		let outDuration = 1.0

		let cloudMaximumScale = CGFloat(1.5)

		let inGroup = SKAction.group([SKAction.fadeInWithDuration(inDuration), SKAction.scaleTo(cloudMaximumScale, duration: inDuration)])
		self.cloudNode?.runAction(inGroup, completion: { () -> Void in

			self.cloudNode.removeFromParent()
			self.texture = self.cloudTexture
			self.setScale(cloudMaximumScale)

			let fadeOutAction = SKAction.fadeOutWithDuration(outDuration)
			let scaleDownAction = SKAction.scaleTo(0.8, duration: outDuration)
			let outGroup = SKAction.group([fadeOutAction, scaleDownAction])

			self.runAction(outGroup, completion: { () -> Void in
				self.runAction(SKAction.removeFromParent(), completion: block)
			})
		})
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
