//
//  NoteMapScrollView.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxSwift

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
		zoomScale = 0.3
		bindSave()
	}
}

extension NoteMapScrollView {
    func updateTheme() {
        noteMap.updateTheme()
    }
    
    func scrollTo(point: CGPoint) {
        setContentOffset(point, animated: true)
        saveCoords()
    }
    
    func scrollToCenter() {
        scrollTo(point: noteMap.center)
    }
    
    func loadCoords() {
        current_x = UserDefaults.standard.integer(forKey: "currentx")
        current_y = UserDefaults.standard.integer(forKey: "currenty")
        current_z = UserDefaults.standard.double(forKey: "currentz")
        if current_z != 0 && current_y >= 0 && current_x >= 0 {
            let viewingPoint = CGPoint(x: current_x, y: current_y)
            zoomScale = CGFloat(current_z)
            contentOffset = viewingPoint
            print("[Loaded Coords] zoomScale: \(zoomScale), contentOffset: \(contentOffset), viewingPoint: \(viewingPoint)")
        } else {
            scrollToCenter()
            print("Scrolling to Center")
        }
    }
}

extension NoteMapScrollView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return noteMap
	}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        current_x = Int(scrollView.contentOffset.x)
        current_y = Int(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        current_z = Double(scrollView.zoomScale)
		saveCoords()
    }
}

extension NoteMapScrollView {
	func saveCoords() {
		UserDefaults.standard.set(current_x, forKey: "currentx")
		UserDefaults.standard.set(current_y, forKey: "currenty")
		UserDefaults.standard.set(current_z, forKey: "currentz")
	}
	
	func bindSave() {
		SaveDataObservable.subscribe(onNext: {
			self.saveCoords()
		})
	}
}
