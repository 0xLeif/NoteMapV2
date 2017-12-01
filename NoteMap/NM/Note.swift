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
	case low = 10
	case mid = 20
	case high = 30
}

class Note: UITextView {

	fileprivate let noteSize = CGSize(width: 500, height: 500)
	private var newPoint: CGPoint = .zero
    var disposeBag = DisposeBag()
    var noteDidPanObservable = PublishSubject<Note>()
    var updateParentObservable = PublishSubject<Void>()

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
        delegate = self
		backgroundColor = color
		layer.borderColor = UIColor.black.cgColor
		layer.cornerRadius = 15
		layer.zPosition = 10
		isScrollEnabled = false

		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)
        
        inputAccessoryView = setUpLocalColorPicker()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setUpLocalColorPicker() -> UIView{
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 48))
        for color in colorData{
            guard let index = colorData.index(of: color) else{
                return UIView()
            }
            let width  = Int(UIScreen.width) / colorData.count
            let button : UIButton = UIButton(frame: CGRect(x: index * width, y: 0, width: width, height: 48))
            button.backgroundColor = color
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = color == backgroundColor ? 2 : 0
            button.addTarget(self, action: #selector(localColorPicked), for: .touchDown)
            view.addSubview(button)
        }
        return view
    }

    @objc func localColorPicked(sender: UIButton){
        let buttons = inputAccessoryView?.subviews.flatMap{ $0 as? UIButton }
        for button in buttons!{
            button.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
        backgroundColor = sender.backgroundColor
        noteDidPanObservable.onNext(self)

    }
    
	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.setTranslation(CGPoint.zero, in: self)
		newPoint = CGPoint(x: center.x + translation.x * transform.a, y: center.y + translation.y * transform.a)
		if CGRect(origin: .zero, size: noteMapSize).contains(newPoint) {
			center = newPoint
			noteDidPanObservable.onNext(self)
		} else {
			UINotificationFeedbackGenerator().notificationOccurred(.error)
		}
	}
}

extension Note: UITextViewDelegate {
    //max characters: 384
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textAlignment = NSTextAlignment.center
        
        let textViewSize = textView.frame.size
        let fixedWidth = textViewSize.width-100
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(1000)))
        
        var expectFont = textView.font
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(500))).height > textViewSize.height && (textView.font!.pointSize > CGFloat(24))) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height:  CGFloat(500))).height < textViewSize.height && (textView.font!.pointSize < CGFloat(100))) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont
        }
        return true;
    }
}
