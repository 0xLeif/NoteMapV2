//
//  NoteMapScrollView.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxSwift

protocol Themeable {
	func updateTheme()
}

protocol Deletable {
	func delete()
}

var current_x: Double = 0
var current_y: Double = 0
var current_z: Double = 0

class NoteMapScrollView: UIScrollView {
	fileprivate var noteMap: NoteMap
    fileprivate var disposeBag = DisposeBag()
	var centerViewPoint: CGPoint {
		return contentOffset
	}
	var noteMapBackgroundColor: UIColor? {
		return noteMap.backgroundColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		noteMap = NoteMap()
		super.init(coder: aDecoder)
		NMinit()
	}
	
	private func NMinit() {
		addSubview(noteMap)
		contentSize = noteMap.bounds.size
		delegate = self
		minimumZoomScale = 0.01
		maximumZoomScale = 1
		zoomScale = 0.5
		bindSave()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        current_x = Double(scrollView.contentOffset.x)
        current_y = Double(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        current_z = Double(scrollView.zoomScale)
    }
}

extension NoteMapScrollView {
	func bindSave() {
		SaveDataObservable.subscribe(onNext: {
			UserDefaults.standard.set(current_x, forKey: "xcoord")
			UserDefaults.standard.set(current_y, forKey: "ycoord")
			UserDefaults.standard.set(current_z, forKey: "zcoord")
			print("x: \(current_x), y: \(current_y), z: \(current_z)")
		})
	}
}
