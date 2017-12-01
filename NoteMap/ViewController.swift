//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
enum Colors {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
}

//let colorData = [UIColor.rgba(231, 76, 60,1.0), UIColor.rgba(230, 126, 34,1.0), UIColor.rgba(241, 196, 15,1.0), UIColor.rgba(46, 204, 113,1.0), UIColor.rgba(52, 152, 219,1.0), UIColor.rgba(122, 68, 193,1.0)]
let colorData = [UIColor.rgba(193, 72, 72, 1), UIColor.rgba(224, 127, 79, 1), UIColor.rgba(239, 201, 76, 1), UIColor.rgba(104, 155, 109, 1), UIColor.rgba(76, 122, 137, 1), UIColor.rgba(145, 96, 140, 1)]

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
	let bottomSheet = BottomSheet(startingColor: colorData[0])
    
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .black
		
        load()
		noteMapScrollView.scrollToCenter()
	}
    
    func load(){
		view.addSubview(bottomSheet)
	}
}
