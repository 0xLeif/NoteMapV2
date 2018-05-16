//
//  Global.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import UIKit
import RxSwift

//MARK: Struct
struct NMDefaults: Codable {
    var selectedColor: Color
    var selectedTheme: Theme
}

//MARK: RX
var SaveDataObservable = PublishSubject<Void>()
var LoadDataObservable = PublishSubject<String>()
var selectedTheme: Variable<Theme> = Variable(.light)
var selectedColor: Variable<Color> = Variable(.red)
var colorData: [Color: UIColor] {
    return selectedTheme.value == .dark ? Singleton.darkTheme : Singleton.lightTheme
}
var backgroundColorData: UIColor {
    return selectedTheme.value == .dark ? Singleton.darkBackGround : Singleton.lightBackGround
}
var selectedUIColor: UIColor {
    return colorData[selectedColor.value]!
}
