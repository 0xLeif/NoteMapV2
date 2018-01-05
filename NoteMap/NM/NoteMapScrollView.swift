//
//  NoteMapScrollView.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

protocol Themeable {
	func updateTheme()
}

protocol Deleteable {
	func delete()
}

class NoteMapScrollView: UIScrollView {
	fileprivate var noteMap: NoteMap
	var centerViewPoint: CGPoint {
		return contentOffset
	}
	var noteMapBackgroundColor: UIColor? {
		return noteMap.backgroundColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		noteMap = NoteMap()
		super.init(coder: aDecoder)
		addSubview(noteMap)
		contentSize = noteMap.bounds.size
		delegate = self
		minimumZoomScale = 0.01
		maximumZoomScale = 1
		zoomScale = 0.5
	}
	
	func updateTheme() {
		noteMap.updateTheme()
	}
	
	func scrollTo(point: CGPoint) {
		setContentOffset(point, animated: true)
	}
	
	func scrollToCenter() {
		scrollTo(point: noteMap.center)
	}
}

extension NoteMapScrollView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return noteMap
	}
}
