//
//  Protocol.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation

protocol SnapshotProtocol {
    func generateSnapshot() -> Any
}

protocol LogAnalytic {
    func logAnalytic()
}

protocol Themeable {
    func updateTheme()
}

protocol Deletable {
    func delete()
}
