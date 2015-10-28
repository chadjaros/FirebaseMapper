//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class CollectionPropertyMapping<T, U:SingleId>: PropertyMapping<T> {
    
    typealias Added = (T, U) -> Void
    typealias Removed = (T, U) -> Void
    typealias Changed = (T, U) -> Void
    typealias Getter = (T) -> FirebaseCollection<U>

    let getter:Getter
    let codec: StringCodec<U>?

    override var isCollection: Bool {
        get {
            return true
        }
    }

    init(_ uri: String, _ connectIndicator: ConnectIndicator, _ getter: Getter, _ codec: StringCodec<U>? = nil) {
        self.getter = getter
        self.codec = codec
        super.init(uri, connectIndicator)
    }
    
    func get(instance: T) -> FirebaseCollection<U> {
        return getter(instance)
    }
}
