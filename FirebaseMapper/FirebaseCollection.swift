//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class FirebaseCollection<T:CollectionItem> {

    func value(atIndex: Int) -> T! {
        return nil
    }

    func value(withKey: String) -> T? {
        return nil
    }

    func indexForValue(value: T) -> Int! {
        return nil
    }

    func containsKey(value: String) -> Bool {
        return false;
    }

    var count: Int {
        get {
            return 0
        }
    }

}

class MutableFirebaseCollection<T:CollectionItem>: FirebaseCollection<T> {

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

    override func value(withKey: String) -> T? {
        if let index = self.hashedCollection[withKey] {
            return self.orderedCollection[index]
        }
        return nil
    }

    override func indexForValue(value: T) -> Int {
        if let index = self.hashedCollection[value.id] {
            return index
        }
        return -1
    }

    override var count: Int {
        get {
            return self.orderedCollection.count
        }
    }



}