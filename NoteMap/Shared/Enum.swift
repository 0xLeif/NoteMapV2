//
//  Enum.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation

//MARK: Themes
@objc enum Color: Int, Codable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
}

@objc enum Theme: Int, Codable {
    case light
    case dark
}


//MARK: Analytics
@objc enum Component: Int {
    case Notemap
    case Cluster
    case Note
}
