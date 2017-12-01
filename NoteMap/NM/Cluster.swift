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

    private let checkingPadding: CGFloat = 500

    fileprivate var notes: Variable<[Note]> = Variable([])
    fileprivate var disposeBag = DisposeBag()

    var removedNoteObservable = PublishSubject<Note>()
    var checkNotemapConsume = PublishSubject<Void>()

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
        notesArraySubscriber().disposed(by: disposeBag)
        add(note: note)

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(note: Note) {
        notes.value.append(note)
    }
	
	func remove(note: Note) {
		guard let index = notes.value.index(of: note) else {
			return
		}
		notes.value.remove(at: index)
        rebindArray()
        removedNoteObservable.onNext(note)
	}
    
    func updateView() {
        isHidden = notes.value.count == 1
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
        return note.center.distanceFrom(point: centerPoint) < min(checkingDistance, maxRadius) && note.backgroundColor == backgroundColor?.withAlphaComponent(1)
    }
	
	func canConsume(cluster: Cluster) -> Bool {
		return center.distanceFrom(point: cluster.center) <= (sizeForNotes / 2) + 250
	}
	
	func consume(cluster: Cluster) {
		let clustersNotes = cluster.notes
        cluster.disposeBag = DisposeBag()
		cluster.notes = Variable([])
        clustersNotes.value.forEach { self.add(note: $0) }
	}

    func noteDidPan(forNote note: Note) {
        updateView()
        if !check(note:  note) {
            remove(note: note)
        } else {
            checkNotemapConsume.onNext(())
        }
    }

    func deleteNote(forNote note: Note) {
        guard let noteIndex = notes.value.index(of: note) else {
            return
        }
        notes.value.remove(at: noteIndex).removeFromSuperview()
    }
	
	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x * self.transform.a, y: sender.view!.center.y + translation.y * self.transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
		notes.value.forEach{ $0.center = CGPoint(x: $0.center.x + translation.x * self.transform.a, y: $0.center.y + translation.y * self.transform.a) }
        checkNotemapConsume.onNext(())
	}
}


extension Cluster {
    func notesArraySubscriber() -> Disposable {
        return notes.asObservable().subscribe(onNext: { note in

            self.updateView()

            var arrayOfNoteObservables = [Observable<Note>]()
            self.notes.value.forEach{ (arrayOfNoteObservables.append($0.noteDidPanObservable)) }
            self.notePanMerge(forArray: arrayOfNoteObservables).disposed(by: self.disposeBag)

            var arrayOfDeleteNote = [Observable<Note>]()
            self.notes.value.forEach{ (arrayOfDeleteNote.append($0.deleteNoteObservable)) }
            self.noteDeleteMerge(forArray: arrayOfDeleteNote).disposed(by: self.disposeBag)
        })
    }

    func rebindArray() {
        disposeBag = DisposeBag()
        notesArraySubscriber().disposed(by: disposeBag)
    }
}