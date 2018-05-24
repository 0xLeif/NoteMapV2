
//  Collab.swift
//  NoteMap
//
//  Created by Parshav Chauhan on 5/19/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

class Collab {
    
    private var ref: DatabaseReference = Database.database().reference()
    private var disposeBag = DisposeBag()
    
    // Poor test of dbRef
    func bindCluster(cluster: Cluster) {
        self.ref.child("Cluster").setValue(cluster.id)
        cluster.notePanObservable.do(onSubscribe: {
            self.ref.child("Cluster").child("\(cluster.id)").child("Note").setValue("1")
        }).subscribe(onNext: { note in
            print("in collab note")
            
            self.ref.child("Cluster").child("\(cluster.id)").child("Note").child("1").child("Color").setValue("\(note.color)")
            self.ref.child("Cluster").child("\(cluster.id)").child("Note").child("1").child("Center").setValue("\(note.center)")
        }).disposed(by: disposeBag)
    }
    
    func dispose() {
        disposeBag = DisposeBag()
    }
}
