//
//  ViewController.swift
//  NoteMap
//
//  Created by Zach Eriksen on 6/23/17.
//  Copyright © 2017 oneleif. All rights reserved.
//
import RxSwift
import UIKit


class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
	@IBOutlet weak var themeToggle: UIBarButtonItem!
	var colorPicker: NMColorField!
	let colorPickerView: UIPickerView = UIPickerView()
	
    @IBOutlet var toolbarView: UIView!
    var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .black
		navigationController?.navigationBar.shadowImage = UIImage()
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
	
	@objc func toggleTheme() {
		guard let toggle = themeToggle.customView as? UISwitch else {
			return
		}
		selectedTheme.value = toggle.isOn ? .dark : .light
	}
	
	@objc func donePressed() {
		colorPicker.resignFirstResponder()
	}
}

extension ViewController {
    
    fileprivate func updateTheme() {
        noteMapScrollView.updateTheme()
        updateThemeToggle()
        colorPickerView.reloadAllComponents()
        colorPicker.backgroundColor = selectedUIColor
        colorPickerView.backgroundColor = noteMapScrollView.noteMapBackgroundColor
    }
    
    fileprivate func bindObservables() {
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
    
    fileprivate func updateThemeToggle() {
        guard let theme = themeToggle.customView as? UISwitch else {
            return
        }
        theme.thumbTintColor = selectedUIColor
    }
    
    fileprivate func createColorPicker() {
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
            colorPicker.inputAccessoryView = toolbarView
            colorPicker.backgroundColor = selectedUIColor
        }
        
        let inputView = createInputView()
        let toolbar = createToolbar()
        createColorTextField(withInputView: inputView, andToolbar: toolbar)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: colorPicker)
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
