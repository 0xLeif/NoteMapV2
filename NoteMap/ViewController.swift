//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//
import RxSwift
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
enum Theme: String {
    case light = "light"
    case dark = "dark"
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
var selectedTheme: Variable<Theme> = Variable(.light)
var selectedColor: Variable<Color> = Variable(.red)
var colorData: [NMColor] {
	return selectedTheme.value == .dark ? darkTheme : lightTheme
}
var backgroundColorData: UIColor {
	return selectedTheme.value == .dark ? darkBackGround : lightBackGround
}
var selectedUIColor: UIColor {
	return (colorData.filter{ $0.color == selectedColor.value }.first?.uicolor)!
}

let mockJsonData =
		"""
		{"clusters":[{"notes":[{"center":[18930.565034116524,38512.21754534565]},{"center":[17558.4949555535,39577.197808182646]},{"center":[18782.472960697447,42029.74474272153]},{"center":[20301.780579816335,40612.94883102019]},{"center":[17629.3239749151,41312.13303509432]}],"center":[18640.52750101978,40408.84839247287]},{"notes":[{"center":[21302.842702831767,42119.6648922478]},{"center":[20306.544466581738,45590.719979617454]},{"center":[20314.16816807454,44790.25575110297]},{"center":[22037.07201026651,45788.930285860224]},{"center":[23195.839390726658,44447.1996531682]}],"center":[21431.293347696246,44547.354112399335]}]}
		"""

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
	@IBOutlet weak var themeToggle: UIBarButtonItem!
	var colorPicker: NMColorField!
	let colorPickerView: UIPickerView = UIPickerView()
	
	var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .black
		noteMapScrollView.loadCoords()
		guard let theme = themeToggle.customView as? UISwitch else {
			return
		}
		theme.thumbTintColor = selectedUIColor
		theme.addTarget(self, action: #selector(toggleTheme), for: .allTouchEvents)
		createColorPicker()
		updateTheme()
		bindObservables()
		if let model = UserDefaults.standard.string(forKey: "nm") {
			LoadDataObservable.onNext(model)
		}
	}
	
	private func bindObservables() {
		selectedTheme.asObservable().subscribe(onNext: { (theme) in
			guard let toggle = self.themeToggle.customView as? UISwitch else {
				return
			}
			toggle.isOn = selectedTheme.value == .dark
			self.updateTheme()
		}).disposed(by: disposeBag)
		selectedColor.asObservable().subscribe(onNext: { (color) in
			self.colorPicker.backgroundColor = selectedUIColor
			self.updateThemeToggle()
		}).disposed(by: disposeBag)
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
			let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 44))
			var items = [UIBarButtonItem]()
			let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
			items.append(doneButton)
			toolbar.barStyle = .black
			toolbar.setItems(items, animated: true)
			return toolbar
		}
		func createColorTextField(withInputView inputView: UIPickerView, andToolbar toolbar: UIToolbar) {
			colorPicker = NMColorField(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
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
		selectedTheme.value = toggle.isOn ? .dark : .light
	}
	
	private func updateTheme() {
		noteMapScrollView.updateTheme()
		updateThemeToggle()
		colorPickerView.reloadAllComponents()
		colorPicker.backgroundColor = selectedUIColor
		colorPickerView.backgroundColor = noteMapScrollView.noteMapBackgroundColor
	}
	
	@objc func donePressed() {
		colorPicker.resignFirstResponder()
	}
}

extension ViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedColor.value = Color(rawValue: row)!
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
