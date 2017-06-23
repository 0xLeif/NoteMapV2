//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Add Note
		let note = Note(atCenter: .init(x: 100, y: 100), withColor: .blue)
		view.addSubview(note)
	}
}
