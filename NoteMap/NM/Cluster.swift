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

    private let checkingPadding: CGFloat = 500
    private var disposeBag = DisposeBag()

    private var notes: Variable<[Note]> = Variable([])
    var removedNoteObservable = PublishSubject<Note>()
    var checkNotemapConsume = PublishSubject<Void>()

    private lazy var theMerge:([Observable<Note>]) -> Disposable = { forArray in
        return Observable.merge(forArray).subscribe { event in
            event.map { note in
                self.noteDidPan(forNote: note)
            }
        }
    }

    private lazy var theArray:() -> Disposable = {
        return self.notes.asObservable().subscribe(onNext: { note in
            if (self.notes.value.count != 0) {

                //self.isHidden = self.notes.value.count == 1
                self.updateView()

                var arrayOfNoteObservables = [Observable<Note>]()
                self.notes.value.forEach{ (arrayOfNoteObservables.append($0.fixedNoteObservable)) }
                self.theMerge(arrayOfNoteObservables).disposed(by: self.disposeBag)
            }
        })
    }

	var maxRadius: CGFloat {
		return CGFloat(notes.value.count) * checkingPadding
	}
	var sizeForNotes: CGFloat {
		let currentCenter = centerPoint
		return (notes.value.map{ ($0.center.distanceFrom(point: currentCenter)) + checkingPadding}.sorted(by: >).first ?? 0) * 2
	}
    var centerPoint: CGPoint {
        let centerPoints = notes.value.map{ $0.center }
        let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
        let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
                                centerPoints.map{ $0.y }.reduce(0, +))
        let (avgX, avgY) = (totalX / numberOfPoints,
                            totalY / numberOfPoints)
        return notes.value.isEmpty ? .zero : CGPoint(x: avgX, y: avgY)
    }
    
    init(note: Note) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        backgroundColor = note.backgroundColor?.withAlphaComponent(0.25)
        center = note.center
        layer.zPosition = 5
        layer.masksToBounds = false
        theArray().disposed(by: self.disposeBag)
        add(note: note)

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
        print("added not : \(note.text)")
        notes.value.append(note)
    }
	
	func remove(note: Note) {
		guard let index = notes.value.index(of: note) else {
			return
		}
		notes.value.remove(at: index)
        disposeBag = DisposeBag()
        theArray().disposed(by: disposeBag)
        removedNoteObservable.onNext(note)
        print("cluster.remove")
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
			layer.borderWidth = CGFloat(notes.value.count) * 10
		} else {
			layer.borderWidth = 0
		}
	}
    
    func check(note: Note) -> Bool{
		let checkingDistance = (sizeForNotes / 2) + (notes.value.count == 1 ? checkingPadding : 0)
        return note.center.distanceFrom(point: centerPoint) < min(checkingDistance, maxRadius) && note.backgroundColor == notes.value.first?.backgroundColor
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return center.distanceFrom(point: cluster.center) <= (sizeForNotes / 2) + 250
	}
	
	func checkConsume() {
        checkNotemapConsume.onNext(())
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
        cluster.disposeBag = DisposeBag()
		cluster.notes = Variable([])
        clustersNotes.value.forEach { self.add(note: $0) }
        disposeBag = DisposeBag()
        theArray().disposed(by: self.disposeBag)
	}

    private func disposeMerge(a: Disposable) {
        a.dispose()
    }

    func noteDidPan(forNote note: Note) {
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
		notes.value.forEach{ $0.center = CGPoint(x: $0.center.x + translation.x * self.transform.a, y: $0.center.y + translation.y * self.transform.a) }
        checkNotemapConsume.onNext(())
	}
}