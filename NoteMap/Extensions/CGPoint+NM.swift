//
//  CGPoint+NM.swift
//  NoteMap
//
//  Created by Zach Eriksen on 10/31/17.
//  Copyright © 2017 oneleif. All rights reserved.
//

import UIKit

extension CGPoint {
    func distanceFrom(point: CGPoint) -> CGFloat {
        let xDist = (x - point.x)
        let yDist = (y - point.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        return distance
    }
}
