//
//  BottomSheet.swift
//  NoteMap
//
//  Created by Zach Eriksen on 11/13/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

class BottomSheet: UIView {
	var colorPickerView: UIPickerView = UIPickerView()
	var colorField: UITextField = UITextField()
	var importancePickerView: UIPickerView = UIPickerView()
	var importanceField: UITextField = UITextField()
	
	init(startingColor: UIColor) {
		selectedColor = startingColor
		super.init(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.height - 64 ), size: CGSize(width: UIScreen.width, height: 500)))
		backgroundColor = .gray
		layer.cornerRadius = 16
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panMenu))
		addGestureRecognizer(panGesture)
		
		createIndicator()
		createColorButton()
		createImportanceButton()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func panMenu(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y * transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
	}
	var dragView: UIView = UIView()
	private func createIndicator() {
		dragView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 32)
		dragView.backgroundColor = .lightGray
		let indicatorView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 48, height: 8)))
		indicatorView.backgroundColor = .gray
		indicatorView.center = dragView.center
		indicatorView.layer.cornerRadius = 4
		dragView.addSubview(indicatorView)
		addSubview(dragView)
	}
	
	private func createColorButton(){
		//creating textfields with a pickerview
		colorPickerView.delegate = self
		colorPickerView.dataSource = self
		colorPickerView.frame = CGRect(x: 100, y: 100, width: 25, height: 300)
		colorPickerView.backgroundColor = .black
		
		colorField = UITextField()
		colorField.center = CGPoint(x: 0, y: 32)
		colorField.frame.size = CGSize(width: 64, height: 64)
		colorField.inputView = colorPickerView
		colorField.backgroundColor = selectedColor
//		let path = UIBezierPath(roundedRect:colorField.bounds,
//								byRoundingCorners:[.topLeft],
//								cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
//
//
//		let maskLayer = CAShapeLayer()
//
//		maskLayer.path = path.cgPath
//		colorField.layer.mask = maskLayer
		addSubview(colorField)
	}
	
	private func createImportanceButton() {
		importancePickerView.delegate = self
		importancePickerView.dataSource = self
		importancePickerView.frame = CGRect(x: 100, y: 100, width: 25, height: 300)
		importancePickerView.backgroundColor = .black
		
		importanceField = UITextField()
		importanceField.center = CGPoint(x: bounds.width - 64, y: 32)
		importanceField.frame.size = CGSize(width: 64, height: 64)
		importanceField.inputView = importancePickerView
		importanceField.backgroundColor = selectedColor
		importanceField.textAlignment = .center
		importanceField.text = "\(selectedImportance)"
//		let path = UIBezierPath(roundedRect:importanceField.bounds,
//								byRoundingCorners:[.topRight],
//								cornerRadii: CGSize(width: layer.cornerRadius, height: layer.cornerRadius))
//
//
//		let maskLayer = CAShapeLayer()
//
//		maskLayer.path = path.cgPath
//		importanceField.layer.mask = maskLayer
		addSubview(importanceField)
	}
}


extension BottomSheet: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView === colorPickerView {
			colorField.backgroundColor = colorData[row]
			selectedColor = colorData[row]
		} else {
			importanceField.text = "\(importanceData[row])"
			selectedImportance = importanceData[row]
		}
	}
}
extension BottomSheet: UIPickerViewDataSource{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == colorPickerView {
			return colorData.count
		} else {
			return importanceData.count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let pickerLabel = UILabel()
		if pickerView == colorPickerView {
			let titleData = colorData[row]
			pickerLabel.backgroundColor = titleData
		} else {
			let titleData = importanceData[row]
			pickerLabel.backgroundColor = selectedColor
			pickerLabel.textAlignment = .center
			pickerLabel.text = "\(titleData)"
		}
		return pickerLabel
	}
}
