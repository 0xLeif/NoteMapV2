//
//  BottomSheet.swift
//  NoteMap
//
//  Created by Zach Eriksen on 11/13/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

var selectedColor: UIColor?

class BottomSheet: UIView {
	var colorPickerView: UIPickerView = UIPickerView()
	var colorField: UITextField = UITextField()
	
	init(startingColor: UIColor) {
		selectedColor = startingColor
		super.init(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.height - 64 ), size: CGSize(width: UIScreen.width, height: 500)))
		backgroundColor = .gray
		layer.cornerRadius = 16
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panMenu))
		addGestureRecognizer(panGesture)
		
		createIndicator()
		createColorButton()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func panMenu(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: self)
		center = CGPoint(x: center.x, y: center.y + translation.y * transform.a)
		sender.setTranslation(CGPoint.zero, in: self)
	}
	
	private func createIndicator() {
		let indicatorView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 48, height: 8)))
		indicatorView.backgroundColor = .lightGray
		indicatorView.center = CGPoint(x: bounds.width / 2, y: 16)
		indicatorView.layer.cornerRadius = 4
		addSubview(indicatorView)
	}
	
	private func createColorButton(){
		//creating textfields with a pickerview
		colorPickerView.delegate = self
		colorPickerView.dataSource = self
		colorPickerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
		colorPickerView.backgroundColor = .clear
		
		colorField = UITextField(frame: CGRect(x: 0, y: 48, width: bounds.width, height: 30))
		colorField.inputView = colorPickerView
		colorField.backgroundColor = selectedColor

		addSubview(colorField)
	}
	
}


extension BottomSheet: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		colorField.backgroundColor = colorData[row]
		selectedColor = colorData[row]
	}
}
extension BottomSheet: UIPickerViewDataSource{
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
