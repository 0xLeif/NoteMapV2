//
// Created by Parshav Chauhan on 1/2/18.
// Copyright (c) 2018 oneleif. All rights reserved.
//

import Foundation
import UIKit

struct NoteModel: Placeable {
    var center: CGPoint
}

struct ClusterModel: Placeable {

    var notes: [NoteModel]

    var center: CGPoint
}

struct NoteMapModel: Codable {
    var clusters: [ClusterModel]
}

struct MapModel: Codable {
    var notemaps: [NoteMapModel]
}

protocol Placeable: Codable {
    var center: CGPoint { get set }
    //var color: UIColor { get set }
}