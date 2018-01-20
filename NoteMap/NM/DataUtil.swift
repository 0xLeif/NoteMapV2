//
// Created by Parshav Chauhan on 1/2/18.
// Copyright (c) 2018 oneleif. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct NoteModel: Codable {
    var center: CGPoint
    var color: Int
	var text: String
}

struct ClusterModel: Codable {
    var notes: [NoteModel]
}

struct NoteMapModel: Codable {
    var clusters: [ClusterModel]
    var settings: NMDefaults
}

struct NMDefaults: Codable {
    var selectedColor: Int
    var secletedTheme: String
}

protocol SnapshotProtocol {
    func generateSnapshot() -> Any
}

var SaveDataObservable = PublishSubject<Void>()
var LoadDataObservable = PublishSubject<String>()
