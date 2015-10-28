//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

protocol FirebaseConnectionProvider {

    func createConnection<T>(instance: T) -> FirebaseConnection<T>
}

class DefaultFirebaseConnectionProvider: FirebaseConnectionProvider {

    static let INSTANCE = DefaultFirebaseConnectionProvider()

    func createConnection<T>(instance: T) -> FirebaseConnection<T> {
        return FirebaseConnection<T>(instance)
    }
}

// This is because of the compile error: Class stored properties not yet supported in generic types
// The original attempt was to put provider into the FirebaseMappable class
class FirebaseConnectionService {
    static var provider: FirebaseConnectionProvider = DefaultFirebaseConnectionProvider()
}