//
//  Cluster.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Cluster: UIView {

    var notemap: NoteMap?
    var noteCenter = PublishSubject<CGPoint?>()
    var noteObservable: Observable<Note>!

    private let checkingPadding: CGFloat = 500
    private let disposeBag = DisposeBag()

	var notes: [Note] = [] {
        didSet {
			isHidden = notes.count == 1
            updateView()

            var arrayOfNoteObservables = [Observable<Note>]()
            notes.map{ (arrayOfNoteObservables.append($0.noteObservable))}
			Observable.merge(arrayOfNoteObservables).subscribe { event in
                event.map { note in
                    self.noteDidPan(forNote: note)
                    }
                }.disposed(by: disposeBag)
            }
    }
	var maxRadius: CGFloat {
		return CGFloat(notes.count) * checkingPadding
	}
	var sizeForNotes: CGFloat {
		let currentCenter = centerPoint
		return (notes.map{ ($0.center.distanceFrom(point: currentCenter)) + checkingPadding}.sorted(by: >).first ?? 0) * 2
	}
    var centerPoint: CGPoint {
        let centerPoints = notes.map{ $0.center }
        let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
        let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
                                centerPoints.map{ $0.y }.reduce(0, +))
        let (avgX, avgY) = (totalX / numberOfPoints,
                            totalY / numberOfPoints)
        return notes.isEmpty ? .zero : CGPoint(x: avgX, y: avgY)
    }
    
    init(note: Note) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        backgroundColor = note.backgroundColor?.withAlphaComponent(0.25)
        center = note.center
        layer.zPosition = 5
        layer.masksToBounds = false
        add(note: note)

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
		note.setNew(parent: self)
        notes.append(note)
    }
	
	func remove(note: Note) {
		guard let index = notes.index(of: note) else {
			return
		}
		notes.remove(at: index)
		note.setNew(parent: nil)
		notemap?.addCluster(forNote: note)
	}
    
    func updateView() {
        frame = CGRect(origin: .zero, size: CGSize(width: sizeForNotes, height: sizeForNotes))
		checkBorder()
        center = centerPoint
        layer.cornerRadius = sizeForNotes / 2
    }
	
	private func checkBorder() {
		if (sizeForNotes / 2) >= maxRadius {
			layer.borderColor = backgroundColor?.withAlphaComponent(1).cgColor
			layer.borderWidth = CGFloat(notes.count) * 10
		} else {
			layer.borderWidth = 0
		}
	}
    
    func check(note: Note) -> Bool{
		let checkingDistance = (sizeForNotes / 2) + (notes.count == 1 ? checkingPadding : 0)
        return note.center.distanceFrom(point: centerPoint) < min(checkingDistance, maxRadius) && note.backgroundColor == notes.first?.backgroundColor
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return center.distanceFrom(point: cluster.center) <= (sizeForNotes / 2) + 250
	}
	
	func checkConsume() {
		notemap?.checkConsume()
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
		clustersNotes.forEach{ $0.setNew(parent: self) }
		cluster.notes = []
		notes.append(contentsOf: clustersNotes)
	}

    private func noteDidPan(forNote note: Note) {
        self.updateView()
        if !self.check(note:  note) {
            self.remove(note: note)
        } else {
            self.checkConsume()
        }
    }
	
	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x * self.transform.a, y: sender.view!.center.y + translation.y * self.transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
		notes.forEach{ $0.center = CGPoint(x: $0.center.x + translation.x * self.transform.a, y: $0.center.y + translation.y * self.transform.a) }
		checkConsume()
	}
}