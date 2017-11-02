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
		minimumZoomScale = 0.01
		maximumZoomScale = 4
	}
}

extension NoteMapScrollView: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return noteMap
	}
}
