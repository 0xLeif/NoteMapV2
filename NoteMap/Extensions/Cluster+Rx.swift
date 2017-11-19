//
// Created by Parshav Chauhan on 11/18/17.
// Copyright (c) 2017 oneleif. All rights reserved.
//

import RxCocoa
import RxSwift

extension Cluster {

    func notePanMerge(forArray observableArray: [Observable<Note>]) -> Disposable {
        return Observable.merge(observableArray).subscribe(onNext: { note in
            self.noteDidPan(forNote: note)
        })
    }
}