//
//  Note.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum NoteImportance: CGFloat {
	// The values are for the borderWidth
	case none = 0
	case low = 3
	case medium = 6
	case high = 9
}

class Note: UITextView {

	fileprivate let noteSize = CGSize(width: 500, height: 500)

	var parentCluster: Cluster?
    var disposeBag = DisposeBag()
    var noteObservable: Observable<Note>!

    var importance: NoteImportance = .none {
		didSet {
			layer.borderWidth = importance.rawValue
		}
	}
	
	init(atCenter point: CGPoint, withColor color: UIColor) {
		super.init(frame: CGRect(origin: .zero, size: noteSize), textContainer: nil)
		adjustsFontForContentSizeCategory = true
		font = UIFont.systemFont(ofSize: 16)
		center = point
		backgroundColor = color
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 15
		layer.zPosition = 10
		isScrollEnabled = false

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setNew(parent: Cluster?) {
		parentCluster = parent
        if (parentCluster != nil) {
            let centerVariable = PublishSubject<CGPoint?>()
            self.rx.observe(CGPoint.self, "center").bind(to: centerVariable).disposed(by: disposeBag)
            self.noteObservable = centerVariable.asObservable().map{ item in
                return self
            }

        }
	}

	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x * self.transform.a, y: sender.view!.center.y + translation.y * self.transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
	}
}
