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
	fileprivate var notes: [(UIView, Note)] = []
	var selectedColor: UIColor = .cyan
	var cluster: Cluster = Cluster()
	
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
		let note = Note(atCenter: point, withColor: selectedColor)
		let length = sqrt(pow(note.bounds.width / 2, 2) + pow(note.bounds.height / 2, 2)) * 2
		let clusterView = Cluster()
		clusterView.backgroundColor = .black
		clusterView.layer.cornerRadius = length / 2
		notes.append((clusterView, note))
		cluster.notes.append(note)
		
        addSubview(clusterView)
		addSubview(note)
	}
	
}
