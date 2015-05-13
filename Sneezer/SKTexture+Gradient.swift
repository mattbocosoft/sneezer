//
//  SKTexture+Gradient.swift
//  Sneezer
//
//  Created by Matthew Thomas on 5/13/15.
//  Copyright (c) 2015 William Loftus. All rights reserved.
//

import UIKit
import SpriteKit

extension SKTexture {

	class func textureWithVerticalGradientOfSize(size: CGSize, topColor: CIColor, bottomColor: CIColor) -> SKTexture {

		let coreImageContext = CIContext(options: nil)
		let gradientFilter = CIFilter(name: "CILinearGradient")
		gradientFilter.setDefaults()
		

		let startVector = CIVector(x: size.width/2, y: 0)
		let endVector = CIVector(x: size.width/2, y: size.height)
		gradientFilter.setValue(startVector, forKey: "inputPoint0")
		gradientFilter.setValue(endVector, forKey: "inputPoint1")
		gradientFilter.setValue(bottomColor, forKey: "inputColor0")
		gradientFilter.setValue(topColor, forKey: "inputColor1")

		let cgimg = coreImageContext.createCGImage(gradientFilter.outputImage, fromRect: CGRectMake(0, 0, size.width, size.height))
		return SKTexture(image: UIImage(CGImage: cgimg)!)
	}
	
}
