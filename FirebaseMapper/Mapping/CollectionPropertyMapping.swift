//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

protocol CollectionItem: SingleId {

    init(id: String, copy: Self?)
}

class CollectionPropertyMapping<ModelType, ChildType: CollectionItem>: PropertyMapping<ModelType> {

    typealias Getter = (ModelType) -> MutableFirebaseCollection<ChildType>
    typealias OnChildUpdate = (ModelType, ChildType) -> Void

    let getter: Getter
    let didAdd: OnChildUpdate
    let didRemove: OnChildUpdate
    let didChange: OnChildUpdate
    let codec: DictionaryCodec<ChildType>

    override var isCollection: Bool {
        get {
            return true
        }
    }

    init(
            uri: String,
            connectIndicator: ConnectIndicator,
            getter: Getter,
            didAdd: OnChildUpdate,
            didRemove: OnChildUpdate,
            didChange: OnChildUpdate,
            codec: DictionaryCodec<ChildType>) {
            
        self.getter = getter
        self.didAdd = didAdd
        self.didRemove = didRemove
        self.didChange = didChange
        self.codec = codec
        super.init(uri, connectIndicator)
    }
    
    func get(instance: ModelType) -> MutableFirebaseCollection<ChildType> {
        return getter(instance)
    }
}
