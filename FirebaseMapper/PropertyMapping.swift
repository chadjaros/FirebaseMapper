//
//  PropertyMapping.swift
//  SwiftMapper
//
//  Created by Chad Jaros on 10/26/15.
//  Copyright © 2015 Classkick. All rights reserved.
//

import UIKit

class PropertyMappingBase<T>: NSObject {

    let firebaseUri:String;

    init(_ firebaseUri: String) {
        self.firebaseUri = firebaseUri;
    }
}

class PropertyMapping<T, U>: PropertyMappingBase<T> {

    typealias Setter = (T, U) -> Void;
    typealias Getter = (T) -> U;

    let setter:Setter;
    let getter:Getter;
    let codec: StringCodec<U>?;

    init(_ firebaseUri: String, _ getter: Getter, _ setter: Setter, _ codec: StringCodec<U>? = nil) {
        self.getter = getter
        self.setter = setter
        self.codec = codec
        super.init(firebaseUri)
    }

    func get(instance: T) -> U {
        return getter(instance)
    }

    func set(instance: T, value: U) {
        setter(instance, value)
    }

    func getEncoded(instance: T) -> String! {
        return codec?.encode(getter(instance))
    }

    func setEncoded(instance: T, value: String) {
        if(codec != nil) {
            return setter(instance, codec!.decode(value))
        }
    }
}
