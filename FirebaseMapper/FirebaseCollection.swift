//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class FirebaseCollection<T:SingleId> {

    func value(atIndex: Int) -> T! {
        return nil
    }

    func value(withId: String) -> T! {
        return nil
    }

    var count: Int {
        get {
            return 0
        }
    }
}

class MutableFirebaseCollection<T:SingleId>: FirebaseCollection<T> {

    private var orderedCollection: [T]
    private var hashedCollection: [String: Int]

    override init() {
        self.orderedCollection = [T]()
        self.hashedCollection = [String: Int]()
        super.init()
    }

    override func value(atIndex: Int) -> T {
        return self.orderedCollection[atIndex]
    }

    override func value(withId: String) -> T {
        return self.orderedCollection[self.hashedCollection[withId]!]
    }

    override var count: Int {
        get {
            return self.orderedCollection.count
        }
    }


}