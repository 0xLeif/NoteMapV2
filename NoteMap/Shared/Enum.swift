//
//  Enum.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation

//MARK: Themes
enum Color: Int, Codable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
}

enum Theme: String, Codable {
    case light = "light"
    case dark = "dark"
}


//MARK: Analytics
enum Component: String {
    case Notemap
    case Cluster
    case Note
}
