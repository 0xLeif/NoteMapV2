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
		let multiplier: CGFloat = 100
		return CGSize(width: UIScreen.width * multiplier, height: UIScreen.height * multiplier)
	}
    fileprivate var clusters: [Cluster] = []
    fileprivate var notes: [Note] = []
    var selectedColor: UIColor?
    
	init() {
		super.init(frame: CGRect(origin: .zero, size: noteMapSize))
		backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
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
	
	func addCluster(forNote note: Note) {
		if note.parentCluster != nil {
			print("WARNING: Note already has a parent!")
		}
		
		let noClusterInRange = clusters.map{ $0.check(note: note) }.filter{ $0 }.isEmpty
		
		if noClusterInRange {
			let cluster = Cluster(note: note)
			cluster.notemap = self
			clusters.append(cluster)
			addSubview(cluster)
			sendSubview(toBack: cluster)
		} else {
			let collidedClusters = clusters.filter{ $0.check(note: note) }
			var distFromNote: [CGFloat: Cluster] = [:]
			collidedClusters.forEach{ distFromNote[$0.centerPoint.distanceFrom(point: note.center)] = $0 }
			let min = collidedClusters.map{ $0.centerPoint.distanceFrom(point: note.center) }.sorted(by: <).first!
			let cluster = distFromNote[min]
			cluster?.add(note: note)
		}
	}
	
	private func addNote(atCenter point: CGPoint) {
        guard let color = selectedColor else {
            print("invalid color")
            return
        }
		let note = Note(atCenter: point, withColor: color)
		
		addCluster(forNote: note)
		
		checkConsume()
		
        notes.append(note)
        addSubview(note)
	}
	
	func checkConsume() {
		for cluster in clusters {
			let collidingClusters = clusters.filter{ check(lhs: cluster, rhs: $0) }
			if !collidingClusters.isEmpty {
				for c in collidingClusters {
					guard let clusterIndex = clusters.index(of: c) else {
						return
					}
					cluster.consume(cluster: c)
					clusters.remove(at: clusterIndex).removeFromSuperview()
				}
			}
		}
	}
    
    
    func checkBounds(of: Cluster, forTranslation point: CGPoint) -> Bool {
        let badNotes = of.notes.filter{ !bounds.contains(CGPoint(x: $0.center.x + point.x, y: $0.center.y + point.y)) }
        return badNotes.isEmpty
    }
	
	private func check(lhs: Cluster, rhs: Cluster) -> Bool {
		return lhs.canConsume(cluster: rhs) && lhs !== rhs && lhs.backgroundColor == rhs.backgroundColor
    }
}
