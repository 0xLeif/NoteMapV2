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

class Note: UITextView {

	fileprivate let noteSize = CGSize(width: 500, height: 500)
	private var newPoint: CGPoint = .zero
    var disposeBag = DisposeBag()
    var noteDidPanObservable = PublishSubject<Note>()
    var updateParentObservable = PublishSubject<Void>()
    var deleteNoteObservable = PublishSubject<Note>()
	
	var color: Color

	init(atCenter point: CGPoint, withColor color: Color, withText text: String? = nil) {
		self.color = color
		super.init(frame: CGRect(origin: .zero, size: noteSize), textContainer: nil)
		NMinit(atCenter: point)
		self.text = text
		resizeText()
	}
	
	private func NMinit(atCenter point: CGPoint) {
		adjustsFontForContentSizeCategory = true
		font = UIFont.systemFont(ofSize: 100)
		center = point
		delegate = self
		backgroundColor = colorData.filter{ $0.color == color }.first?.uicolor
		layer.borderColor = UIColor.black.cgColor
		layer.cornerRadius = 15
		layer.zPosition = 10
		isScrollEnabled = false
		tintColor = .white
		textAlignment = .center
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		panGestureRecognizer.maximumNumberOfTouches = 1
		addGestureRecognizer(panGestureRecognizer)
		
		let deleteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteSelf))
		deleteTapRecognizer.numberOfTouchesRequired = 2
		deleteTapRecognizer.numberOfTapsRequired = 2
		addGestureRecognizer(deleteTapRecognizer)
		
        inputAccessoryView = setUpLocalColorPicker()
    }
	
	private func resizeText() {
		let textViewSize = frame.size
		let fixedWidth = textViewSize.width-100
		let expectSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(1000)))
		
		var expectFont = font
		if (expectSize.height > textViewSize.height) {
			while (sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(500))).height > textViewSize.height && (font!.pointSize > CGFloat(24))) {
				expectFont = font!.withSize(font!.pointSize - 1)
				font = expectFont
			}
		}
		else {
			while (sizeThatFits(CGSize(width: fixedWidth, height:  CGFloat(500))).height < textViewSize.height && (font!.pointSize < CGFloat(100))) {
				expectFont = font;
				font = font!.withSize(font!.pointSize + 1)
			}
			font = expectFont
		}
	}
	
	@objc func deleteSelf() {
		delete()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setUpLocalColorPicker() -> UIView{
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 48))
		var count = 0
        for color in colorData {
            let width  = Int(UIScreen.width) / colorData.count
            let button: UIButton = UIButton(frame: CGRect(x: count * width, y: 0, width: width, height: 48))
            button.backgroundColor = color.uicolor
            button.layer.borderColor = UIColor.white.cgColor
			button.tag = count
            button.layer.borderWidth = color.uicolor == backgroundColor ? 2 : 0
            button.addTarget(self, action: #selector(localColorPicked), for: .touchDown)
            view.addSubview(button)
			count += 1
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
		color = Color(rawValue: sender.tag)!
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

extension Note: Themeable {
	func updateTheme() {
		backgroundColor = colorData.filter{ $0.color == color}.first?.uicolor
		inputAccessoryView = setUpLocalColorPicker()
		if isFirstResponder {
			resignFirstResponder()
		}
	}
}

extension Note: Deletable {
	func delete() {
		removeFromSuperview()
		deleteNoteObservable.onNext(self)
	}
}

extension Note: SnapshotProtocol {
    func generateSnapshot() -> Any {
		return NoteModel(center: center, color: color.rawValue, text: text)
    }
}

extension Note: UITextViewDelegate {
    //max characters: 384
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		
        
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
