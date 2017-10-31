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
	
    var centerPoint: CGPoint {
        let centerPoints = notes.map{ $0.center }
        let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
        let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
                                centerPoints.map{ $0.y }.reduce(0, +))
        let (avgX, avgY) = (totalX / numberOfPoints,
                            totalY / numberOfPoints)
        return CGPoint(x: avgX, y: avgY)
    }
    
    var sizeForNotes: CGSize {
        let bigger = max(currentWidth, currentHeight)
        return CGSize(width: bigger, height: bigger)
    }
    
    var currentWidth: CGFloat {
        let currentCenter = centerPoint
        let maxNoteDistance = notes.map{ abs($0.center.x - currentCenter.x) }.sorted(by: >).first ?? 0
        return maxNoteDistance * 2
    }
    
    var currentHeight: CGFloat {
        let currentCenter = centerPoint
        let maxNoteDistance = notes.map{ abs($0.center.y - currentCenter.y) }.sorted(by: >).first ?? 0
        return maxNoteDistance * 2
    }
}
