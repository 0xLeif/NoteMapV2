//
//  Cluster.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxSwift

class Cluster: UIView {
    private let checkingPadding: CGFloat = 500
    
    //TODO: talk about pulling out lines 16-32 in here and Note.swift
    private var panGestureRecognizer: UIPanGestureRecognizer {
        let pgr = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
        pgr.maximumNumberOfTouches = 1
        return pgr
    }
    private var deleteTapRecognizer: UITapGestureRecognizer {
        let tgr = UITapGestureRecognizer(target: self, action: #selector(deleteSelf))
        tgr.numberOfTouchesRequired = 2
        tgr.numberOfTapsRequired = 3
        return tgr
    }

    fileprivate var notes: Variable<Set<Note>> = Variable(Set<Note>())
    fileprivate var disposeBag = DisposeBag()

    var removedNoteObservable = PublishSubject<Note>()
    var checkNotemapConsume = PublishSubject<Cluster>()

	private var newPoint: CGPoint = .zero
	private var inBounds: Bool = true
	
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
        add(note: note)
        NMinit()
    }

    init(notes: [Note]){
        super.init(frame: .zero)
        backgroundColor = notes.first?.backgroundColor?.withAlphaComponent(0.25)
        notes.forEach{ add(note: $0) }
        NMinit()
    }
    
	private func NMinit() {
        center = centerPoint
		layer.zPosition = 5
		layer.masksToBounds = false
		notesArraySubscriber().disposed(by: disposeBag)
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(deleteTapRecognizer)
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	@objc func deleteSelf() {
		delete()
	}
	
	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		newPoint = sender.translation(in: self)
		sender.setTranslation(CGPoint.zero, in: self)
		if inBounds {
			center = CGPoint(x: center.x + newPoint.x * transform.a, y: center.y + newPoint.y * transform.a)
			notes.value.forEach{ $0.center = CGPoint(x: $0.center.x + newPoint.x * transform.a, y: $0.center.y + newPoint.y * transform.a) }
		} else {
			UINotificationFeedbackGenerator().notificationOccurred(.error)
		}
		checkNotemapConsume.onNext(self)
	}
}

extension Cluster {
    func check(bounds: CGRect) {
        inBounds = notes.value.filter{ !bounds.contains(CGPoint(x: $0.center.x + newPoint.x, y: $0.center.y + newPoint.y)) }.isEmpty
    }
    
    func add(note: Note) {
        notes.value.insert(note)
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
    
    //TODO:
    //func checkTitlePosition()
    
    func canConsume(cluster: Cluster) -> Bool {
        return center.distanceFrom(point: cluster.center) <= (sizeForNotes / 2)
    }
    
    func consume(cluster: Cluster) {
        let clustersNotes = cluster.notes
        cluster.disposeBag = DisposeBag()
        cluster.notes = Variable([])
        clustersNotes.value.forEach { add(note: $0) }
    }
    
    func noteDidPan(forNote note: Note) {
        if !check(note:  note) {
            remove(note: note)
        } else {
            checkNotemapConsume.onNext(self)
        }
        updateView()
    }
    
    func deleteNote(forNote note: Note) {
        guard let noteIndex = notes.value.index(of: note) else {
            return
        }
        notes.value.remove(at: noteIndex)
    }
}

extension Cluster: LogAnalytic {
    func logAnalytic() {
        Singleton.log(type: .Cluster)
    }
}

extension Cluster: Themeable {
	func updateTheme() {
		notes.value.forEach{ $0.updateTheme() }
		backgroundColor = notes.value.first?.backgroundColor?.withAlphaComponent(0.25)
	}
}

extension Cluster: Deletable {
	func delete() {
		notes.value.forEach{ $0.delete() }
		notes.value = []
		removeFromSuperview()
	}
}

extension Cluster: SnapshotProtocol {
    func generateSnapshot() -> Any {
        var modelArray: [NoteModel] = []
        notes.value.forEach { modelArray.append($0.generateSnapshot() as! NoteModel) }
        let model  = ClusterModel(notes: modelArray)
        return model
    }
}

extension Cluster {
    func notePanMerge(forArray observableArray: [Observable<Note>]) -> Disposable {
        return Observable.merge(observableArray).subscribe(onNext: { note in
            self.noteDidPan(forNote: note)
        })
    }
    
    func noteDeleteMerge(forArray observableArray: [Observable<Note>]) -> Disposable {
        return Observable.merge(observableArray).subscribe(onNext: { note in
            self.deleteNote(forNote: note)
        })
    }
    
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
