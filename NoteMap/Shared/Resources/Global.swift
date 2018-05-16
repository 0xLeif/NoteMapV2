//
//  Global.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import UIKit
import RxSwift

//MARK: Structs
struct NMDefaults: Codable {
    var selectedColor: Color
    var selectedTheme: Theme
}

struct NMColor {
    var color: Color
    var uicolor: UIColor
}

//MARK: RX
var SaveDataObservable = PublishSubject<Void>()
var LoadDataObservable = PublishSubject<String>()
var selectedTheme: Variable<Theme> = Variable(.light)
var selectedColor: Variable<Color> = Variable(.red)

//MARK: Test Data
let testTheme: [Color: UIColor] = [.red: .rgba(231, 76, 60,1.0)]
let mockJsonData =
"""
{"clusters":[{"notes":[{"center":[18930.565034116524,38512.21754534565]},{"center":[17558.4949555535,39577.197808182646]},{"center":[18782.472960697447,42029.74474272153]},{"center":[20301.780579816335,40612.94883102019]},{"center":[17629.3239749151,41312.13303509432]}],"center":[18640.52750101978,40408.84839247287]},{"notes":[{"center":[21302.842702831767,42119.6648922478]},{"center":[20306.544466581738,45590.719979617454]},{"center":[20314.16816807454,44790.25575110297]},{"center":[22037.07201026651,45788.930285860224]},{"center":[23195.839390726658,44447.1996531682]}],"center":[21431.293347696246,44547.354112399335]}]}
"""
