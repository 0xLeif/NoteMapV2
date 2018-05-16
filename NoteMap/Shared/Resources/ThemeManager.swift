//
//  ThemeManger.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import UIKit

struct ThemeManager {
    static let darkTheme: [Color: UIColor] = [.red: .rgba(231, 76, 60,1.0),
                                              .orange:  .rgba(230, 126, 34,1.0),
                                              .yellow: .rgba(241, 196, 15,1.0),
                                              .green: .rgba(46, 204, 113,1.0),
                                              .blue: .rgba(52, 152, 219,1.0),
                                              .purple: .rgba(122, 68, 193,1.0)]
    static let lightTheme: [Color: UIColor] = [ .red: .rgba(193, 72, 72, 1),
                              .orange: .rgba(224, 127, 79, 1),
                              .yellow: .rgba(239, 201, 76, 1),
                              .green: .rgba(104, 155, 109, 1),
                              .blue: .rgba(76, 122, 137, 1),
                              .purple: .rgba(145, 96, 140, 1)]
    static let darkBackGround: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    static let lightBackGround: UIColor = .rgba(236, 240, 241,1.0)
}

var colorData: [Color: UIColor] {
    return selectedTheme.value == .dark ? ThemeManager.darkTheme : ThemeManager.lightTheme
}
var backgroundColorData: UIColor {
    return selectedTheme.value == .dark ? ThemeManager.darkBackGround : ThemeManager.lightBackGround
}
var selectedUIColor: UIColor {
    return (colorData[selectedColor.value])!
}
