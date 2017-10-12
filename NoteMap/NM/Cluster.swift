//
//  Cluster.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class Cluster: UIView {
	var notes: [Note] = []
	
 func findCenterPointForNotes() -> CGPoint {
		let centerPoints = notes.map{ $0.center }
		let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
		let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
		                        centerPoints.map{ $0.y }.reduce(0, +))
		let (avgX, avgY) = (totalX / numberOfPoints,
		                    totalY / numberOfPoints)
		return CGPoint(x: avgX, y: avgY)
	}
}
