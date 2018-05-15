//
//  NoteModel.swift
//  NoteMap
//
//  Created by Zach Eriksen on 5/14/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation
import UIKit

struct NoteModel: Codable {
    var center: CGPoint
    var color: Int
    var text: String
}
