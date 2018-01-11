//
//  AnalyticsService.swift
//  NoteMap
//
//  Created by Parshav Chauhan on 1/10/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsService {
    
    static func log(type: Component) {
        Analytics.logEvent("Init", parameters: [
            "Type": type.rawValue as NSObject
            ])
    }
}

protocol LogAnalytic {
    func logAnalytic()
}

enum Component: String {
    case Notemap = "Notemap"
    case Cluster = "Cluster"
    case Note = "Note"
}
