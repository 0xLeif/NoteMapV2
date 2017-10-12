//
//  NoteMapScrollView.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class NoteMapScrollView: UIScrollView {
	fileprivate var noteMap: NoteMap
	
	required init?(coder aDecoder: NSCoder) {
		noteMap = NoteMap()
		super.init(coder: aDecoder)
		addSubview(noteMap)
		contentSize = noteMap.bounds.size
		delegate = self
		minimumZoomScale = 0.1
		maximumZoomScale = 4
		test()
	}
	
	
	
	func test () {
		
		let note = Note(atCenter: .init(x: 100, y: 100), withColor: .blue)
		let note2 = Note(atCenter: .init(x: 300, y: 275), withColor: .green)
		let note3 = Note(atCenter: .init(x: 100, y: 350), withColor: .orange)
		
		noteMap.addSubview(note)
		noteMap.addSubview(note2)
		noteMap.addSubview(note3)
		
		note.importance = .low
		note2.importance = .medium
		note3.importance = .high
	}
	
}

extension NoteMapScrollView: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return noteMap
	}
}
