//
//  Cluster.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class Cluster: UIView {
    private var checkingCircle: UIView = UIView()
    private let checkingPadding: CGFloat = 250
    var notes: [Note] = [] {
        didSet {
            updateView()
        }
    }
	
    var centerPoint: CGPoint {
        let centerPoints = notes.map{ $0.center }
        let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
        let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
                                centerPoints.map{ $0.y }.reduce(0, +))
        let (avgX, avgY) = (totalX / numberOfPoints,
                            totalY / numberOfPoints)
        return notes.isEmpty ? .zero : CGPoint(x: avgX, y: avgY)
    }
    
    var sizeForNotes: CGFloat {
        return max(currentWidth, currentHeight)
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
    
    init(note: Note) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        backgroundColor = .black
        center = note.center
        layer.zPosition = 5
        checkingCircle.layer.zPosition = 2
        addSubview(checkingCircle)
        layer.masksToBounds = false
        add(note: note)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
        notes.append(note)
    }
    
    func updateView() {
        frame = CGRect(origin: .zero, size: CGSize(width: sizeForNotes, height: sizeForNotes))
        center = centerPoint
        layer.cornerRadius = sizeForNotes / 2
        
        let checkSize = sizeForNotes + checkingPadding
        checkingCircle.frame = CGRect(origin: .zero, size: CGSize(width: checkSize, height: checkSize))
        checkingCircle.center = CGPoint(x: sizeForNotes/2, y: sizeForNotes/2)
        checkingCircle.layer.cornerRadius = checkSize / 2
        checkingCircle.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
    }
    
    func check(note: Note) -> Bool{
        return note.center.distanceFrom(point: centerPoint) <= (sizeForNotes / 2) + checkingPadding
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return frame.intersection(cluster.frame).size != .zero
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
		cluster.notes = []
		notes.append(contentsOf: clustersNotes)
	}
}
