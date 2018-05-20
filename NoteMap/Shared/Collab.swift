//
//  Collab.swift
//  NoteMap
//
//  Created by Parshav Chauhan on 5/19/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Collab {
    
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
}
