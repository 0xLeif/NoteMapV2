//
// Created by Parshav Chauhan on 1/2/18.
// Copyright (c) 2018 oneleif. All rights reserved.
//

import Foundation
import UIKit

struct NoteModel {
    var center: CGPoint
    var color: UIColor
}

struct NoteMapModel {
    var notes: [NoteModel]
}

struct Map : Codable {
    var notemap: [NoteMapModel]
}