//
//  Note.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
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
	var importance: NoteImportance = .none {
		didSet {
			layer.borderWidth = importance.rawValue
		}
	}
    var colorPickerView: UIView = UIView()
    
    
	
	init(atCenter point: CGPoint, withColor color: UIColor) {
		super.init(frame: CGRect(origin: .zero, size: noteSize), textContainer: nil)
		adjustsFontForContentSizeCategory = true
		font = UIFont.systemFont(ofSize: 16)
		center = point
        delegate = self
		backgroundColor = color
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 15
		layer.zPosition = 10
		isScrollEnabled = false
        
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
		addGestureRecognizer(panGestureRecognizer)
        
        let localColorPicker = setUpLocalColorPicker()
        inputAccessoryView = localColorPicker
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setNew(parent: Cluster?) {
		parentCluster = parent
	}
	
    func setUpLocalColorPicker() -> UIView{
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 40))
        for color in colorData{
            guard let index = colorData.index(of: color) else{
                return UIView()
            }
            let width  = Int(UIScreen.width) / colorData.count
            let button : UIButton = UIButton(frame: CGRect(x: index * width, y: 0, width: width, height: 40))
            button.backgroundColor = color
            button.addTarget(self, action: #selector(localColorPicked), for: .touchDown)
            view.addSubview(button)
        }
        return view
    }
    @objc func localColorPicked(sender: UIButton){
        backgroundColor = sender.backgroundColor
        updateParent()
    }
    
	@objc func userDidPan(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x * self.transform.a, y: sender.view!.center.y + translation.y * self.transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
		updateParent()
    }
    
    private func updateParent() {
        guard let parent = parentCluster else {
            return
        }
        if !parent.check(note: self) {
            parent.remove(note: self)
        } else {
            parent.noteDidPan()
        }
        parent.updateView()
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
