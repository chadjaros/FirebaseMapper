//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

protocol CollectionItem: SingleId {

    init(id: String, copy: Self?)
}

class CollectionPropertyMapping<T, U: CollectionItem>: PropertyMapping<T> {

    typealias Getter = (T) -> FirebaseCollection<U>
    typealias CollectionUpdateNotification = (T, U) -> Void

    let getter: Getter
    let didAdd: CollectionUpdateNotification
    let didRemove: CollectionUpdateNotification
    let didChange: CollectionUpdateNotification
    let codec: Codec<U, [String: String]>?

    override var isCollection: Bool {
        get {
            return true
        }
    }

    init(uri: String,
            connectIndicator: ConnectIndicator,
            getter: Getter,
            didAdd: CollectionUpdateNotification,
            didRemove: CollectionUpdateNotification,
            didChange: CollectionUpdateNotification,
            codec: Codec<U, [String: String]>? = nil) {
            
        self.getter = getter
        self.didAdd = didAdd
        self.didRemove = didRemove
        self.didChange = didChange
        self.codec = codec
        super.init(uri, connectIndicator)
    }
    
    func get(instance: T) -> FirebaseCollection<U> {
        return getter(instance)
    }
}
