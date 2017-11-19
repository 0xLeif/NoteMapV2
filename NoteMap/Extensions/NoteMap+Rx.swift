//
// Created by Parshav Chauhan on 11/18/17.
// Copyright (c) 2017 oneleif. All rights reserved.
//

import RxCocoa
import RxSwift

extension NoteMap {

    func removedNoteMerge(forArray observableArray: [Observable<Note>]) -> Disposable {
        return Observable.merge(observableArray).subscribe(onNext: { note in
            self.addCluster(forNote: note)
        })
    }

    func checkConsumeMerge(forArray observableArray: [Observable<()>]) -> Disposable {
        return Observable.merge(observableArray).subscribe(onNext: { _ in
            self.checkConsume()
        })
    }
}