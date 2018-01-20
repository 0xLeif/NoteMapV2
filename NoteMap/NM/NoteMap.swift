//
//  NoteMap.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public var noteMapSize: CGSize {
	let multiplier: CGFloat = 100
	return CGSize(width: UIScreen.width * multiplier, height: UIScreen.height * multiplier)
}

class NoteMap: UIView {
    fileprivate var clusters: Variable<[Cluster]> = Variable([])
    fileprivate var disposeBag = DisposeBag()

    init() {
		super.init(frame: CGRect(origin: .zero, size: noteMapSize))
		NMinit()
	}
	
	private func NMinit() {
		backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
		
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		addGestureRecognizer(doubleTapGestureRecognizer)
		
		clusterArraySubscriber().disposed(by: disposeBag)
		bindSave()
		bindLoad()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func doubleTap(sender: UITapGestureRecognizer) {
        addNote(atCenter: sender.location(in: self))
	}
	
	func addCluster(forNote note: Note) {

		let noClusterInRange = clusters.value.map{ $0.check(note: note) }.filter{ $0 }.isEmpty
		
		if noClusterInRange {
			let cluster = Cluster(note: note)
            rebindArray()
			clusters.value.append(cluster)
			addSubview(cluster)
			sendSubview(toBack: cluster)
		} else {
			let collidedClusters = clusters.value.filter{ $0.check(note: note) }
			var distFromNote: [CGFloat: Cluster] = [:]
			collidedClusters.forEach{ distFromNote[$0.centerPoint.distanceFrom(point: note.center)] = $0 }
			let min = collidedClusters.map{ $0.centerPoint.distanceFrom(point: note.center) }.sorted(by: <).first!
			let cluster = distFromNote[min]
			cluster?.add(note: note)
		}
	}
	
	private func addNote(atCenter point: CGPoint) {
		let note = Note(atCenter: point, withColor: selectedColor.value)
		
		addCluster(forNote: note)
		
		checkConsume()
		
        addSubview(note)
	}
	
	func checkConsume() {
		for cluster in clusters.value {
			let collidingClusters = clusters.value.filter{ check(lhs: cluster, rhs: $0) }
			if !collidingClusters.isEmpty {
				for c in collidingClusters {
					guard let clusterIndex = clusters.value.index(of: c) else {
						return
					}
					cluster.consume(cluster: c)
                    rebindArray()
					clusters.value.remove(at: clusterIndex).removeFromSuperview()
				}
			}
		}
	}
	
	private func check(lhs: Cluster, rhs: Cluster) -> Bool {
		return lhs.canConsume(cluster: rhs) && lhs !== rhs && lhs.backgroundColor == rhs.backgroundColor
    }
}

extension NoteMap {
    func clusterArraySubscriber() -> Disposable {
        return self.clusters.asObservable().subscribe(onNext: { cluster in

                var arrayOfNoteRemoval = [Observable<Note>]()
                self.clusters.value.forEach { (arrayOfNoteRemoval.append($0.removedNoteObservable)) }
                self.removedNoteMerge(forArray: arrayOfNoteRemoval).disposed(by: self.disposeBag)

                var arrayOfCheckConsumeEvent = [Observable<(Cluster)>]()
                self.clusters.value.forEach { (arrayOfCheckConsumeEvent.append($0.checkNotemapConsume)) }
                self.checkConsumeMerge(forArray: arrayOfCheckConsumeEvent).disposed(by: self.disposeBag)
        })
    }

    func rebindArray() {
        disposeBag = DisposeBag()
        clusterArraySubscriber().disposed(by: disposeBag)
    }
}

extension NoteMap: Themeable {
	
	func updateTheme() {
		clusters.value.forEach{ $0.updateTheme() }
		backgroundColor = backgroundColorData
	}
}

extension NoteMap: SnapshotProtocol {
	func generateSnapshot() -> Any {
		var clusterModels: [ClusterModel] = []
		self.clusters.value.forEach { clusterModels.append($0.generateSnapshot() as! ClusterModel) }
        let settings =  NMDefaults(selectedColor: selectedColor.value.rawValue, secletedTheme: selectedTheme.value.rawValue)
		let model = NoteMapModel(clusters: clusterModels, settings: settings)
		return model
	}
}

extension NoteMap {
	func bindSave() {
		SaveDataObservable.subscribe(onNext: {
			let toBeSavedModel = self.generateSnapshot()
			let b = toBeSavedModel as! NoteMapModel
			let encode = try? JSONEncoder().encode(b)
			let a = String(data: encode!, encoding: String.Encoding.utf8)
            print("Saved data : \(a!)")
            UserDefaults.standard.set(a!, forKey: "nm")
		})
	}
    
	func bindLoad() { LoadDataObservable.subscribe(onNext: { jsonString in
			if let jsonData = jsonString.data(using: .utf8) {
				let model = try? JSONDecoder().decode(NoteMapModel.self, from: jsonData)
                print("Got notemapmodel : \((model as! NoteMapModel))")
				self.loadFromModel(model: model as! NoteMapModel)
			}
		})
	}

	func loadFromModel(model: NoteMapModel) {
		for clusterModel in model.clusters {
			var notes: [Note] = []
			clusterModel.notes.forEach {
				let note = Note(atCenter: $0.center, withColor: Color(rawValue: $0.color)!, withText: $0.text)
				notes.append(note)
				addSubview(note)
			}
           let cluster = Cluster(notes: notes)
            clusters.value.append(cluster)
            addSubview(cluster)
		}
		let color = model.settings.selectedColor
		let theme = model.settings.secletedTheme
		if let loadedColor = Color(rawValue: color),
			let loadedTheme = Theme(rawValue: theme) {
			selectedColor.value = loadedColor
			selectedTheme.value = loadedTheme
		}
	}
}
