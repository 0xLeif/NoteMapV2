//
// Created by Parshav Chauhan on 1/2/18.
// Copyright (c) 2018 oneleif. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

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

protocol Placeable: Codable {
    var center: CGPoint { get set }
    //var color: UIColor { get set }
}

protocol SnapshotProtocol {
    func generateSnapshot() -> BaseModel
}

var SaveDataObservable = PublishSubject<Void>()
var LoadDataObservable = PublishSubject<String>()
typealias BaseModel = (type: ComponentName, model: Any)
enum ComponentName {
    case Note, Cluster, Notemap
}