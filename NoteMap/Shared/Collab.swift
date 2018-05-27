
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
    private let ID = 4.generateRandomNumber()
    
    // First call for setting up db ref
    func bindCluster(cluster: Cluster) {
        cluster.notePanObservable.do(onSubscribe: {
            self.ref.child("\(self.ID)")
        }).subscribe(onNext: { _ in
            
            let modelDict = self.clusterToClusterModelJson(cl: cluster).convertToDictionary()            
            self.ref.child("\(self.ID)").setValue(modelDict)

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

extension Int {
    func generateRandomNumber() -> Int {
        var place = 1
        var finalNumber = 0
        for _ in 0..<self {
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += Int(randomNumber) * place
        }
        return finalNumber
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
