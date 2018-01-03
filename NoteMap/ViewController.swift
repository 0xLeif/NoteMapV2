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


//let colorData = [UIColor.rgba(231, 76, 60,1.0), UIColor.rgba(230, 126, 34,1.0), UIColor.rgba(241, 196, 15,1.0), UIColor.rgba(46, 204, 113,1.0), UIColor.rgba(52, 152, 219,1.0), UIColor.rgba(122, 68, 193,1.0)] // Dark Theme
let colorData = [UIColor.rgba(193, 72, 72, 1), UIColor.rgba(224, 127, 79, 1), UIColor.rgba(239, 201, 76, 1), UIColor.rgba(104, 155, 109, 1), UIColor.rgba(76, 122, 137, 1), UIColor.rgba(145, 96, 140, 1)] // Light Theme
var selectedColor: UIColor = colorData.first!

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
	var colorPicker: UITextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .black
		noteMapScrollView.scrollToCenter()
		createColorPicker()
	}
	
	private func createColorPicker() {
		func createInputView() -> UIPickerView {
			let colorPickerView: UIPickerView = UIPickerView()
			colorPickerView.delegate = self
			colorPickerView.dataSource = self
			colorPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 200)
			colorPickerView.backgroundColor = noteMapScrollView.noteMap.backgroundColor
			return colorPickerView
		}
		func createToolbar() -> UIToolbar{
			let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
			var items = [UIBarButtonItem]()
			let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
			items.append(doneButton)
			toolbar.barStyle = .black
			toolbar.setItems(items, animated: true)
			return toolbar
		}
		func createColorTextField(withInputView inputView: UIPickerView, andToolbar toolbar: UIToolbar) -> UITextField {
			colorPicker = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
			colorPicker.tintColor = .clear
			colorPicker.layer.cornerRadius = 5
			colorPicker.inputView = inputView
			colorPicker.inputAccessoryView = toolbar
			colorPicker.backgroundColor = selectedColor
			return colorPicker
		}
		
		
		let inputView = createInputView()
		let toolbar = createToolbar()
		let pickerView = createColorTextField(withInputView: inputView, andToolbar: toolbar)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: colorPicker)
	}
	
	@objc func donePressed() {
		colorPicker.resignFirstResponder()
	}
}

extension ViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		colorPicker.backgroundColor = colorData[row]
		selectedColor = colorData[row]
	}
}
extension ViewController: UIPickerViewDataSource{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return colorData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let pickerLabel = UILabel()
		pickerLabel.backgroundColor = colorData[row]
		return pickerLabel
	}
}
