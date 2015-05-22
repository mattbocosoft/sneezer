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

	private var nodes: [AngelNode]?
	
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
		
		self.nodes = [AngelNode]()
		
		for i in 0...5 {
			let angelNode = AngelNode()
			angelNode.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
			self.addAngelNode(angelNode)
		}
	}

	//MARK: Helper Function

	private func addAngelNode(node: AngelNode) {

		self.addChild(node)
		node.startFlying()
		
		node.alpha = 0.0
		let fadeIn = SKAction.fadeInWithDuration(1.0)
		
		node.runAction(fadeIn)
		
		let maximumImpulse = UInt32(40)
		let xImpulse = CGFloat(arc4random_uniform(maximumImpulse)) - CGFloat(maximumImpulse)/2.0
		let yImpulse = CGFloat(arc4random_uniform(maximumImpulse)) - CGFloat(maximumImpulse)/2.0
		node.physicsBody?.applyImpulse(CGVectorMake(xImpulse, yImpulse))

		self.nodes?.append(node)
	}
	
	func removeAngel(completion block: (() -> Void)!) {
		
		if let lastAngel = self.nodes?.last {

			self.nodes?.removeLast()

			lastAngel.poof(completion: { () -> Void in

				block()
			})
		} else {
			block()
		}
	}
	
	func angelCount() -> Int {
		
		return nodes?.count ?? 0
	}
	
	//MARK: -

	override func didEvaluateActions() {

		let maxSpeed: CGFloat = 200.0
		let minSpeed: CGFloat = 75.0

		for node in self.nodes! {
			
			if let physicsBody = node.physicsBody {

				let xSpeed = fabs(physicsBody.velocity.dx)
				let ySpeed = fabs(physicsBody.velocity.dy)

				if physicsBody.velocity.dx > maxSpeed {

					physicsBody.velocity = CGVectorMake(maxSpeed, physicsBody.velocity.dy)

				} else if physicsBody.velocity.dx < -maxSpeed {

					physicsBody.velocity = CGVectorMake(-maxSpeed, physicsBody.velocity.dy)

				} else if physicsBody.velocity.dx > 0 {

					if physicsBody.velocity.dx < minSpeed {
						
						physicsBody.velocity = CGVectorMake(minSpeed, physicsBody.velocity.dy)
					}
					
				} else {

					if physicsBody.velocity.dx > -minSpeed {
						
						physicsBody.velocity = CGVectorMake(-minSpeed, physicsBody.velocity.dy)
					}
				}
				
				if physicsBody.velocity.dy > maxSpeed {

					physicsBody.velocity = CGVectorMake(physicsBody.velocity.dx, maxSpeed)

				} else if physicsBody.velocity.dy < -maxSpeed {

					physicsBody.velocity = CGVectorMake(physicsBody.velocity.dx, -maxSpeed)

				} else if physicsBody.velocity.dy > 0 {
					
					if physicsBody.velocity.dy < minSpeed {
						
						physicsBody.velocity = CGVectorMake(physicsBody.velocity.dx, minSpeed)
					}
					
				} else {

					if physicsBody.velocity.dy > -minSpeed {
						
						physicsBody.velocity = CGVectorMake(physicsBody.velocity.dx, -minSpeed)
					}
				}
			}
		}
	}

	override func update(currentTime: NSTimeInterval) {
		
		let maxSpeed: CGFloat = 200.0
		let minSpeed: CGFloat = 10.0
		for node in self.nodes! {
			
			if let physicsBody = node.physicsBody {
				
				if physicsBody.velocity.dx > 0 {
					node.travelLeft()
				} else {
					node.travelRight()
				}
			}
		}
	}
}
