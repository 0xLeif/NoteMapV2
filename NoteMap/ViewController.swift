//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit
enum Color: Int {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
}
let colorOrder: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]

struct NMColor {
	var color: Color
	var uicolor: UIColor
}
let darkTheme = [NMColor(color: .red, uicolor: .rgba(231, 76, 60,1.0)),
				 NMColor(color: .orange, uicolor: .rgba(230, 126, 34,1.0)),
				 NMColor(color: .yellow, uicolor: .rgba(241, 196, 15,1.0)),
				 NMColor(color: .green, uicolor: .rgba(46, 204, 113,1.0)),
				 NMColor(color: .blue, uicolor: .rgba(52, 152, 219,1.0)),
				 NMColor(color: .purple, uicolor: .rgba(122, 68, 193,1.0))]
let lightTheme = [NMColor(color: .red, uicolor: .rgba(193, 72, 72, 1)),
				 NMColor(color: .orange, uicolor: .rgba(224, 127, 79, 1)),
				 NMColor(color: .yellow, uicolor: .rgba(239, 201, 76, 1)),
				 NMColor(color: .green, uicolor: .rgba(104, 155, 109, 1)),
				 NMColor(color: .blue, uicolor: .rgba(76, 122, 137, 1)),
				 NMColor(color: .purple, uicolor: .rgba(145, 96, 140, 1))]
let darkBackGround: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
let lightBackGround: UIColor = .rgba(236, 240, 241,1.0)
var isDarkTheme = false
var colorData: [NMColor] {
	return isDarkTheme ? darkTheme : lightTheme
}
var backgroundColorData: UIColor {
	return isDarkTheme ? darkBackGround : lightBackGround
}
var selectedColor: Color = .red
var selectedUIColor: UIColor {
	return (colorData.filter{ $0.color == selectedColor }.first?.uicolor)!
}

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
	@IBOutlet weak var themeToggle: UIBarButtonItem!
	var colorPicker: UITextField!
	let colorPickerView: UIPickerView = UIPickerView()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .black
		noteMapScrollView.scrollToCenter()
		createColorPicker()
		guard let theme = themeToggle.customView as? UISwitch else {
			return
		}
		theme.thumbTintColor = selectedUIColor
		theme.addTarget(self, action: #selector(toggleTheme), for: .allTouchEvents)
		updateTheme()
	}
	
	private func updateThemeToggle() {
		guard let theme = themeToggle.customView as? UISwitch else {
			return
		}
		theme.thumbTintColor = selectedUIColor
	}
	
	private func createColorPicker() {
		func createInputView() -> UIPickerView {
			colorPickerView.delegate = self
			colorPickerView.dataSource = self
			colorPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 200)
			colorPickerView.backgroundColor = noteMapScrollView.noteMapBackgroundColor
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
		func createColorTextField(withInputView inputView: UIPickerView, andToolbar toolbar: UIToolbar) {
			colorPicker = UITextField(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
			colorPicker.tintColor = .clear
			colorPicker.layer.cornerRadius = 5
			colorPicker.inputView = inputView
			colorPicker.inputAccessoryView = toolbar
			colorPicker.backgroundColor = selectedUIColor
		}
		
		let inputView = createInputView()
		let toolbar = createToolbar()
		createColorTextField(withInputView: inputView, andToolbar: toolbar)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: colorPicker)
	}
	
	@objc func toggleTheme() {
		guard let toggle = themeToggle.customView as? UISwitch else {
			return
		}
		isDarkTheme = !toggle.isOn
		updateTheme()
	}
	
	private func updateTheme() {
		noteMapScrollView.updateTheme()
		updateThemeToggle()
		colorPickerView.reloadAllComponents()
		colorPicker.backgroundColor = selectedUIColor
	}
	
	@objc func donePressed() {
		colorPicker.resignFirstResponder()
	}
}

extension ViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedColor = Color(rawValue: row)!
		colorPicker.backgroundColor = selectedUIColor
		updateThemeToggle()
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
		pickerLabel.backgroundColor = colorData[row].uicolor
		return pickerLabel
	}
}
