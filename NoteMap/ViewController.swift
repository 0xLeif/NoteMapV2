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

class ViewController: UIViewController {
	@IBOutlet weak var noteMapScrollView: NoteMapScrollView!
    
    let colorPickView = UIPickerView()
    let colorData = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    var colorBottomField : UITextField = UITextField()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboardWithBackgroundTap()
		view.backgroundColor = .gray
        
        
        load()
        
	}
    
    func load(){
        createColorButton()
        //TODO: createSettingScrollView()
    }
    
    func createColorButton(){
        //creating textfields with a pickerview
        colorPickView.backgroundColor = .lightGray
        colorPickView.delegate = self
        colorPickView.dataSource = self
        colorPickView.frame = CGRect(x: 100, y: 100, width: 25, height: 300)
        
        colorBottomField = UITextField()
        colorBottomField.center = CGPoint(x: UIScreen.width-96, y: UIScreen.height-96)
        colorBottomField.frame.size = CGSize(width: 192, height: 192)
        colorBottomField.inputView = colorPickView
        colorBottomField.backgroundColor = colorData[0]
        colorBottomField.layer.cornerRadius = colorBottomField.frame.size.width/2
        view.addSubview(colorBottomField)
        view.bringSubview(toFront: colorBottomField)
        
        noteMapScrollView.handleNewGlobalColor(color: colorBottomField.backgroundColor)
    }
    
    @objc func donePressed(){
        
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        noteMapScrollView.handleNewGlobalColor(color: colorData[row])
        colorBottomField.backgroundColor = colorData[row]
    }
}
extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == colorPickView {
            return colorData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        if pickerView == colorPickView {
            let titleData = colorData[row]
            pickerLabel.backgroundColor = titleData
            return pickerLabel
        }
        pickerLabel.text = "\(row+1)"
        return pickerLabel
    }
}
