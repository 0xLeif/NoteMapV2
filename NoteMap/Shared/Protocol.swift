//
//  Protocol.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation

///Returns JSON of object's current state
protocol SnapshotProtocol {
    func generateSnapshot() -> Any
}

///Log object's analytic data
protocol LogAnalytic {
    func logAnalytic()
}

///Updates object's theme
protocol Themeable {
    func updateTheme()
}

///Deletes an object
protocol Deletable {
    func delete()
}
