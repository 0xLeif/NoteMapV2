//
//  ThemeManger.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import UIKit

struct ThemeManager {
    static let darkTheme = [NMColor(color: .red, uicolor: .rgba(231, 76, 60,1.0)),
                     NMColor(color: .orange, uicolor: .rgba(230, 126, 34,1.0)),
                     NMColor(color: .yellow, uicolor: .rgba(241, 196, 15,1.0)),
                     NMColor(color: .green, uicolor: .rgba(46, 204, 113,1.0)),
                     NMColor(color: .blue, uicolor: .rgba(52, 152, 219,1.0)),
                     NMColor(color: .purple, uicolor: .rgba(122, 68, 193,1.0))]
    static let lightTheme = [NMColor(color: .red, uicolor: .rgba(193, 72, 72, 1)),
                      NMColor(color: .orange, uicolor: .rgba(224, 127, 79, 1)),
                      NMColor(color: .yellow, uicolor: .rgba(239, 201, 76, 1)),
                      NMColor(color: .green, uicolor: .rgba(104, 155, 109, 1)),
                      NMColor(color: .blue, uicolor: .rgba(76, 122, 137, 1)),
                      NMColor(color: .purple, uicolor: .rgba(145, 96, 140, 1))]
    static let darkBackGround: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    static let lightBackGround: UIColor = .rgba(236, 240, 241,1.0)
}

var colorData: [NMColor] {
    return selectedTheme.value == .dark ? ThemeManager.darkTheme : ThemeManager.lightTheme
}
var backgroundColorData: UIColor {
    return selectedTheme.value == .dark ? ThemeManager.darkBackGround : ThemeManager.lightBackGround
}
var selectedUIColor: UIColor {
    return (colorData.filter{ $0.color == selectedColor.value }.first?.uicolor)!
}
