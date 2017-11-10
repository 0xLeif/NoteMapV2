//
//  UIColor+NM.swift
//  NoteMap
//
//  Created by Zach Eriksen on 11/6/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

extension UIColor {
		static func randomColor() -> UIColor {
			func randomCGFloat() -> CGFloat {
				return CGFloat(arc4random()) / CGFloat(UInt32.max)
			}
			let r = randomCGFloat()
			let g = randomCGFloat()
			let b = randomCGFloat()
			return UIColor(red: r, green: g, blue: b, alpha: 1.0)
		}
		
		static func rgba(_ r : CGFloat, _ g : CGFloat, _ b :CGFloat, _ a : CGFloat) -> UIColor {
			return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
		}
}
