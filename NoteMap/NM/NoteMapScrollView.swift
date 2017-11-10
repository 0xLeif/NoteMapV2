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
	var centerViewPoint: CGPoint {
		return contentOffset
	}
	
	required init?(coder aDecoder: NSCoder) {
		noteMap = NoteMap()
		super.init(coder: aDecoder)
		addSubview(noteMap)
		contentSize = noteMap.bounds.size
		delegate = self
		minimumZoomScale = 0.01
		maximumZoomScale = 4
	}
    
    func handleNewGlobalColor(color: UIColor?){
        noteMap.selectedColor = color
        
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
