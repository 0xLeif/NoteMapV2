//
//  NoteMapModel.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation

struct NoteMapModel: Codable {
    var clusters: [ClusterModel]
    var settings: NMDefaults
}
