//
//  ModelMapping.swift
//  SwiftMapper
//
//  Created by Chad Jaros on 10/26/15.
//  Copyright © 2015 Classkick. All rights reserved.
//

import UIKit

class ModelMapping<T>: NSObject {

    let firebaseUriBase:String;
    
    private let firebaseToProperty: [String: BasePropertyMapping<T>]
    private let propertyToFirebase: [BasePropertyMapping<T>: String]

    init(firebaseUri: String, properties: [BasePropertyMapping<T>]){
        self.firebaseUriBase = firebaseUri;
        var firebaseMap = [String: BasePropertyMapping<T>]()
        var propertyMap = Dictionary<BasePropertyMapping<T>, String>()

        for property in properties {
            let fireUri = self.firebaseUriBase + property.firebaseUri
            firebaseMap[fireUri] = property
            propertyMap[property] = fireUri
        }
        
        self.firebaseToProperty = firebaseMap
        self.propertyToFirebase = propertyMap
    }
    
    func get<U>(instance: T, _ property: PropertyMapping<T, U>) -> U {
        return property.get(instance);
    }

    func set<U>(instance: T, _ property: PropertyMapping<T, U>, _ value: U) {
        property.set(instance, value: value);
    }
    
    func get<U>(instance: T, _ firebaseUri: String) -> U {
        let template = firebaseUriTemplateFromFull(instance, firebaseUri)
        return get(instance, self.firebaseToProperty[template] as! PropertyMapping<T, U>);
    }
    
    func set<U>(instance: T, _ firebaseUri: String, value: U) {
        let template = firebaseUriTemplateFromFull(instance, firebaseUri)
        set(instance, self.firebaseToProperty[template] as! PropertyMapping<T, U>, value);
    }
    
    func firebaseUri(instance: T, _ property: BasePropertyMapping<T>) -> String {
        return firebaseUriFullFromTemplate(instance, firebaseUriTemplate(property));
    }
    
    func firebaseUriTemplate(property: BasePropertyMapping<T>) -> String {
        return self.propertyToFirebase[property]!;
    }
    
    private func firebaseUriTemplateFromFull(instance: T, _ uri: String) -> String {
        var result = uri;
        let ids = (instance as! MultiId).ids;
        for (key, id) in ids {
            let keyToken = String(format:"{%@}", key)
            result = result.stringByReplacingOccurrencesOfString(id, withString: keyToken);
        }
        return result;
    }

    private func firebaseUriFullFromTemplate(instance: T, _ uri: String) -> String {
        var result = uri;
        let ids = (instance as! MultiId).ids;
        for (key, id) in ids {
            let keyToken = String(format:"{%@}", key)
            result = result.stringByReplacingOccurrencesOfString(keyToken, withString: id);
        }
        return result;
    }
}
