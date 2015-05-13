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
		
		for i in 0...5 {
			let angelNode = AngelNode()
			angelNode.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
			self.addNode(angelNode)
		}
	}

	func removeAngel() {

		if let lastAngel = self.nodes?.last as? AngelNode {
			
			lastAngel.poof()
			self.nodes?.removeLast()
		}
	}

	func angelCount() -> Int {

		return nodes?.count ?? 0
	}

	//MARK: Helper Function

	private func addNode(node: SKNode) {

		node.alpha = 0.0
		self.addChild(node)
		node.runAction(SKAction.fadeInWithDuration(1.0))

		var circle = CAShapeLayer()
		circle.frame = CGRectInset(CGRectMake(160, 160, 320, 320), 50, 50)
		let circlePath = UIBezierPath(ovalInRect:circle.bounds).CGPath

		node.runAction(SKAction.repeatActionForever(SKAction.followPath(circlePath, asOffset: false, orientToPath: true, speed: 40)))
		
		self.nodes?.append(node)
	}

}
