//
//  SimplePropertyMapping.swift
//  SwiftMapper
//
//  Created by Chad Jaros on 10/26/15.
//  Copyright © 2015 Classkick. All rights reserved.
//

import UIKit

class SimplePropertyMapping<ModelType, PropertyType>: PropertyMapping<ModelType> {

    typealias Setter = (ModelType, PropertyType) -> Void
    typealias Getter = (ModelType) -> PropertyType
    typealias OnValueUpdate = (ModelType) -> Void

    let setter: Setter
    let getter: Getter
    let didUpdate: OnValueUpdate?
    let codec: FirebaseValueCodec<PropertyType>

    init(
            uri: String,
            connectIndicator: ConnectIndicator,
            getter: Getter,
            setter: Setter,
            didUpdate: OnValueUpdate? = nil,
            codec: FirebaseValueCodec<PropertyType> = DefaultFirebaseValueCodec<PropertyType>()) {

        self.getter = getter
        self.setter = setter
        self.didUpdate = didUpdate
        self.codec = codec
        super.init(uri, connectIndicator)
    }

    func get(instance: ModelType) -> PropertyType {
        return getter(instance)
    }

    func set(instance: ModelType, value: PropertyType) {

        // Set value
        setter(instance, value)

        // Notify caller
        if let notify = self.didUpdate {
            notify(instance)
        }
    }
}
