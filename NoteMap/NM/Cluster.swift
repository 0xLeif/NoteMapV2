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

    private var notess: Variable<[Note]> = Variable([])

	var maxRadius: CGFloat {
		return CGFloat(notess.value.count) * checkingPadding
	}
	var sizeForNotes: CGFloat {
		let currentCenter = centerPoint
		return (notess.value.map{ ($0.center.distanceFrom(point: currentCenter)) + checkingPadding}.sorted(by: >).first ?? 0) * 2
	}
    var centerPoint: CGPoint {
        let centerPoints = notess.value.map{ $0.center }
        let numberOfPoints: CGFloat = CGFloat(centerPoints.count)
        let (totalX, totalY) = (centerPoints.map{ $0.x }.reduce(0, +),
                                centerPoints.map{ $0.y }.reduce(0, +))
        let (avgX, avgY) = (totalX / numberOfPoints,
                            totalY / numberOfPoints)
        return notess.value.isEmpty ? .zero : CGPoint(x: avgX, y: avgY)
    }
    
    init(note: Note) {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        backgroundColor = note.backgroundColor?.withAlphaComponent(0.25)
        center = note.center
        layer.zPosition = 5
        layer.masksToBounds = false
        notesObservable().disposed(by: disposeBag)
        add(note: note)

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
		note.newParentCluster(parent: self)
        notess.value.append(note)
    }
	
	func remove(note: Note) {
		guard let index = notess.value.index(of: note) else {
			return
		}
		notess.value.remove(at: index)
		note.newParentCluster(parent: nil)
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
			layer.borderWidth = CGFloat(notess.value.count) * 10
		} else {
			layer.borderWidth = 0
		}
	}
    
    func check(note: Note) -> Bool{
		let checkingDistance = (sizeForNotes / 2) + (notess.value.count == 1 ? checkingPadding : 0)
        return note.center.distanceFrom(point: centerPoint) < min(checkingDistance, maxRadius) && note.backgroundColor == notess.value.first?.backgroundColor
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return center.distanceFrom(point: cluster.center) <= (sizeForNotes / 2) + 250
	}
	
	func checkConsume() {
		notemap?.checkConsume()
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notess
		clustersNotes.value.forEach{ $0.newParentCluster(parent: self) }
		cluster.notess = Variable([])
        notess.value.append(contentsOf: clustersNotes.value)
	}

    private func notesObservable()-> Disposable{
        return notess.asObservable().subscribe(onNext: { note in
            if (self.notess.value.count != 0) {
                print("Last note : \(note[self.notess.value.endIndex - 1].center)")

                self.isHidden = self.notess.value.count == 1
                self.updateView()

                var arrayOfNoteObservables = [Observable<Note>]()
                self.notess.value.map{ (arrayOfNoteObservables.append($0.noteObservable)) }
                Observable.merge(arrayOfNoteObservables).subscribe { event in
                    event.map { note in
                        self.noteDidPan(forNote: note)
                    }
                }.disposed(by: self.disposeBag)
            }
        })
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
		notess.value.forEach{ $0.center = CGPoint(x: $0.center.x + translation.x * self.transform.a, y: $0.center.y + translation.y * self.transform.a) }
		checkConsume()
	}
}