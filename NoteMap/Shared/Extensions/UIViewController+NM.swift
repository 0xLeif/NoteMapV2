//
//  ViewController+NM.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

extension UIViewController {
	func hideKeyboardWithBackgroundTap() {
		hideKeyboardWithBackgroundTap(onView: view)
	}
	
	func hideKeyboardWithBackgroundTap(onView view: UIView?) {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view?.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
