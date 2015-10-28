//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class FirebaseMappable<T>: Mappable<T> {

    internal var firebase: FirebaseConnection<T>!

    override init(_ id: String) {
        super.init(id)
        self.firebase = FirebaseConnectionService.provider.createConnection(self as! T)
    }

    override init(_ id: String, _ extraIds: [String: String]) {
        super.init(id, extraIds)
        self.firebase = FirebaseConnectionService.provider.createConnection(self as! T)
    }

    func start() {
        self.firebase.start()
    }

    func stop() {
        self.firebase.stop()
    }
}
