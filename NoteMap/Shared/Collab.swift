
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
            self.ref.child("Cluster").child("Note").setValue("1")
        }).subscribe(onNext: { _ in
            
            let modelDict = self.clusterToClusterModelJson(cl: cluster).convertToDictionary()            
            self.ref.child("Cluster").child("\(cluster.id)").setValue(modelDict)

        }).disposed(by: disposeBag)
    }
    
    func clusterToClusterModelJson(cl: Cluster) -> String {
        let encodedModel = try? JSONEncoder().encode(cl.generateSnapshot() as! ClusterModel)
        return String(data: encodedModel!, encoding: String.Encoding.utf8)!
    }
    
    func dispose() {
        disposeBag = DisposeBag()
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
