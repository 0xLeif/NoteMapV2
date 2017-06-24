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
		let clusterView = UIView(frame: CGRect(origin: CGPoint(x: point.x - length / 2, y: point.y - length / 2 ), size: CGSize(width: length, height: length)))
		clusterView.backgroundColor = .black
		clusterView.layer.cornerRadius = length / 2
		notes.append((clusterView, note))
		addSubview(clusterView)
		addSubview(note)
	}
	
}
