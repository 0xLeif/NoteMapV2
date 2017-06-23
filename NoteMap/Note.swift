//
//  Note.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class Note: UITextView {
	fileprivate let noteSize = CGSize(width: 100, height: 100)
	
	init(atCenter point: CGPoint, withColor color: UIColor) {
		super.init(frame: CGRect(origin: .zero, size: noteSize), textContainer: nil)
		center = point
		backgroundColor = color
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
