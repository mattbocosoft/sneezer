//
//  AngelScene.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

class AngelScene: SKScene {

	private var nodes: [SKNode]?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(size: CGSize) {
		super.init(size: size)

		let topColor = CIColor(red: 134/255, green: 194/255, blue: 253/255)
		let bottomColor = CIColor(red: 22/255, green: 122/255, blue: 239/255)
		let backgroundNode = SKSpriteNode(texture: SKTexture.textureWithVerticalGradientOfSize(self.frame.size, topColor: topColor, bottomColor: bottomColor))
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
		
		self.nodes = [SKSpriteNode]()
		
		for i in 0...0 {
			let angelNode = AngelNode()
			angelNode.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
			self.addNode(angelNode)

//			var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
//			dispatch_after(dispatchTime, dispatch_get_main_queue(), { () -> Void in
//				angelNode.poof()
//			})
		}
	}

	func addNode(node: SKNode) {
		
		self.addChild(node)
		
		node.alpha = 0.0
		let fadeIn = SKAction.fadeInWithDuration(1.0)
		
		node.runAction(fadeIn)
		let maximumImpulse = UInt32(40)
		let xImpulse = CGFloat(arc4random_uniform(maximumImpulse)) - CGFloat(maximumImpulse)/2.0
		let yImpulse = CGFloat(0)
		node.physicsBody?.applyImpulse(CGVectorMake(xImpulse, yImpulse))
		
		self.nodes?.append(node)
	}

}
