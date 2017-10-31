//
//  NoteMap.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class NoteMap: UIView {
	fileprivate var noteMapSize: CGSize {
		let multiplier: CGFloat = 10
		return CGSize(width: UIScreen.width * multiplier, height: UIScreen.height * multiplier)
	}
    fileprivate var clusters: [Cluster] = []
    fileprivate var notes: [Note] = []
	var selectedColor: UIColor = .cyan
	
	init() {
		super.init(frame: CGRect(origin: .zero, size: noteMapSize))
		backgroundColor = .lightGray
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		
		
		addGestureRecognizer(doubleTapGestureRecognizer)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func doubleTap(sender: UITapGestureRecognizer) {
		addNote(atCenter: sender.location(in: self))
	}
	
	private func addNote(atCenter point: CGPoint) {
		var note = Note(atCenter: point, withColor: selectedColor)
       
        let noClusterInRange = clusters.map{ $0.check(note: note) }.filter{ $0 }.isEmpty
        
        if noClusterInRange { 
            let cluster = Cluster(note: note)
            clusters.append(cluster)
            addSubview(cluster)
        } else {
            let collidedClusters = clusters.filter{ $0.check(note: note) }
            var distFromNote: [CGFloat: Cluster] = [:]
            collidedClusters.forEach{ distFromNote[$0.centerPoint.distanceFrom(point: note.center)] = $0 }
            let min = collidedClusters.map{ $0.centerPoint.distanceFrom(point: note.center) }.sorted(by: <).first!
            let cluster = distFromNote[min]
            cluster?.add(note: note)
        }
        notes.append(note)
        addSubview(note)
	}
    
    private func checkForClusterCollision() -> Bool {
        return true
    }
	
}
