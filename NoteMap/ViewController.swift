//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!

	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .gray
	}
	
	
}
