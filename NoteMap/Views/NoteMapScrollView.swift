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
		bindSave().disposed(by: disposeBag)
	}
}

extension NoteMapScrollView {
    func updateTheme() {
        noteMap.updateTheme()
    }
    
    func scrollTo(point: CGPoint) {
        setContentOffset(point, animated: true)
        Singleton.standard().saveCoords()
    }
    
    func scrollToCenter() {
        scrollTo(point: noteMap.center)
    }
    
    func loadCoords() {
        Singleton.standard().loadCoords()
        if Singleton.standard().isCoordsLoaded() {
            print("[Loaded Coords] zoomScale: \(zoomScale), contentOffset: \(contentOffset), viewingPoint: \(Singleton.standard().viewingPoint())")
            zoomScale = Singleton.standard().currentZ
            contentOffset = Singleton.standard().viewingPoint()
        } else {
            scrollToCenter()
            print("Scrolling to Center")
        }
        Singleton.standard().isLoaded = true
    }
}

extension NoteMapScrollView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return noteMap
	}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Singleton.standard().isLoaded {
            Singleton.standard().updateCoords(scrollView.contentOffset)
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        Singleton.standard().currentZ = scrollView.zoomScale
		Singleton.standard().saveCoords()
    }
}

extension NoteMapScrollView {
	func bindSave() -> Disposable {
        return SaveDataObservable.subscribe({_ in
			Singleton.standard().saveCoords()
		})
	}
}
