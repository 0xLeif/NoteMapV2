//
//  Cluster.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class Cluster: UIView {
	var notemap: NoteMap?
	///////////////////
    private var checkingCircle: UIView = UIView()
    private let checkingPadding: CGFloat = 250
    var notes: [Note] = [] {
        didSet {
            updateView()
        }
    }
	var maxRadius: CGFloat {
		return CGFloat(notes.count * 150)
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
        let currentCenter = centerPoint
        return (notes.map{ ($0.center.distanceFrom(point: currentCenter)) + 100}.sorted(by: >).first ?? 0) * 2
    }
    
    init(note: Note) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        backgroundColor = note.backgroundColor?.withAlphaComponent(0.25)
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
		note.setNew(parent: self)
    }
	
	func remove(note: Note) {
		guard let index = notes.index(of: note) else {
			return
		}
		notes.remove(at: index)
		note.setNew(parent: nil)
		notemap?.addCluster(forNote: note)
	}
    
    func updateView() {
        frame = CGRect(origin: .zero, size: CGSize(width: sizeForNotes, height: sizeForNotes))
        center = centerPoint
        layer.cornerRadius = sizeForNotes / 2
		
        let checkSize = sizeForNotes + checkingPadding
        checkingCircle.frame = CGRect(origin: .zero, size: CGSize(width: checkSize, height: checkSize))
        checkingCircle.center = CGPoint(x: sizeForNotes/2, y: sizeForNotes/2)
        checkingCircle.layer.cornerRadius = checkSize / 2
        checkingCircle.backgroundColor = backgroundColor?.withAlphaComponent(0.1)
    }
    
    func check(note: Note) -> Bool{
		let checkingDistance = (sizeForNotes / 2) + checkingPadding
        return note.center.distanceFrom(point: centerPoint) <= min(checkingDistance, maxRadius)
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return frame.intersection(cluster.frame).size != .zero
	}
	
	func noteDidPan() {
		notemap?.checkConsume()
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
		clustersNotes.forEach{ $0.setNew(parent: self) }
		cluster.notes = []
		notes.append(contentsOf: clustersNotes)
	}
}
