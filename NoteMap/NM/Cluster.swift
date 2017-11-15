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
    private let disposeBag = DisposeBag()

    private var notes: Variable<[Note]> = Variable([])
    var clusterObservable: Observable<Cluster>!
    var clusterSizeObservable: Observable<Cluster>!
    var removedNoteObservable = PublishSubject<Note>()
    var doNoteDidPanEvent = PublishSubject<Note>()
    private var centerVariable = PublishSubject<CGPoint?>()
    private var sizeObservable = PublishSubject<CGFloat?>()

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
        notesObservable().disposed(by: disposeBag)
        self.rx.observe(CGFloat.self, "layer.cornerRadius").bind(to: sizeObservable).disposed(by: disposeBag)
        self.rx.observe(CGPoint.self, "center").bind(to: centerVariable).disposed(by: disposeBag)
        clusterObservable = centerVariable.asObservable().map{ item in
            return self
        }
        clusterSizeObservable = sizeObservable.asObservable().map{ item in
            return self
        }

        add(note: note)

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
		note.newParentCluster(parent: self)
        notes.value.append(note)
    }
	
	func remove(note: Note) {
		guard let index = notes.value.index(of: note) else {
			return
		}
		notes.value.remove(at: index)
        removedNoteObservable.onNext(note)
		note.newParentCluster(parent: nil)
		notemap?.addCluster(forNote: note)
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
		notemap?.checkConsume()
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
		clustersNotes.value.forEach{ $0.newParentCluster(parent: self) }
		cluster.notes = Variable([])
        //cluster.removedNoteObservable.dispose()
        centerVariable.dispose()
        cluster.sizeObservable.dispose()
        notes.value.append(contentsOf: clustersNotes.value)
	}

/*    func consume(cluster: Cluster) {
        let clustersNotes = cluster.notes.value
        cluster.sizeObservable.dispose()
        cluster.centerVariable.dispose()
        cluster.removedNoteObservable.dispose()
        cluster.notesObservable().dispose()
        clustersNotes.forEach { add(note: $0) }
        centerVariable.dispose()
        cluster.notes.value.removeAll()
        //notes.value.append(contentsOf: clustersNotes)
    }*/

    private func notesObservable()-> Disposable{
        return notes.asObservable().subscribe(onNext: { note in
            if (self.notes.value.count != 0) {

                //self.isHidden = self.notes.value.count == 1
                self.updateView()

                var arrayOfNoteObservables = [Observable<Note>]()
                self.notes.value.map{ (arrayOfNoteObservables.append($0.noteObservable)) }
                Observable.merge(arrayOfNoteObservables).subscribe { event in
                    event.map { note in
                        //print("did pan")
                        self.noteDidPan(forNote: note)
                        self.doNoteDidPanEvent.onNext(note)
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
		notes.value.forEach{ $0.center = CGPoint(x: $0.center.x + translation.x * self.transform.a, y: $0.center.y + translation.y * self.transform.a) }
	}
}