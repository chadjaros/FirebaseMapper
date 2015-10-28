//
//  ModelMapping.swift
//  SwiftMapper
//
//  Created by Chad Jaros on 10/26/15.
//  Copyright © 2015 Classkick. All rights reserved.
//

import UIKit

class ModelMapping<T>: NSObject {

    let urlBase:String;
    
    let urlTemplateToProperty: [String: PropertyMapping<T>]
    private let propertyToUrlTemplate: [PropertyMapping<T>: String]

    init(uri: String, properties: [PropertyMapping<T>]){
        self.urlBase = uri;
        var urlMap = [String: PropertyMapping<T>]()
        var propertyMap = Dictionary<PropertyMapping<T>, String>()

        for property in properties {
            let urlTemplate = self.urlBase + property.uri
            urlMap[urlTemplate] = property
            propertyMap[property] = urlTemplate
        }
        
        self.urlTemplateToProperty = urlMap
        self.propertyToUrlTemplate = propertyMap
    }
    
    /*
     * Convenience methods for managing basic properties
     */
    func get<U>(instance: T, _ property: SimplePropertyMapping<T, U>) -> U {
        return property.get(instance);
    }

    func set<U>(instance: T, _ property: SimplePropertyMapping<T, U>, _ value: U) {
        property.set(instance, value: value);
    }
    
    func get<U>(instance: T, _ firebaseUri: String) -> U {
        let template = urlTemplateFromFull(instance, firebaseUri)
        return get(instance, self.urlTemplateToProperty[template] as! SimplePropertyMapping<T, U>);
    }
    
    func set<U>(instance: T, _ firebaseUri: String, _ value: U) {
        let template = urlTemplateFromFull(instance, firebaseUri)
        set(instance, self.urlTemplateToProperty[template] as! SimplePropertyMapping<T, U>, value);
    }

    /*
     * Convenience methods for managing collection properties
     */
    
    func get<U>(instance: T, _ property: CollectionPropertyMapping<T, U>) -> FirebaseCollection<U> {
        return property.get(instance);
    }
    
    
    /*
     * Convenience methods for dealing with URIs
     */

    func fullUrl(instance: T, _ property: PropertyMapping<T>) -> String {
        return fullUrlFromTemplate(instance, urlTemplate(property));
    }
    
    func urlTemplate(property: PropertyMapping<T>) -> String {
        return self.propertyToUrlTemplate[property]!;
    }
    
    private func urlTemplateFromFull(instance: T, _ uri: String) -> String {
        var result = uri;
        let ids = (instance as! MultiId).ids;
        for (key, id) in ids {
            let keyToken = String(format:"{%@}", key)
            result = result.stringByReplacingOccurrencesOfString(id, withString: keyToken);
        }
        return result;
    }

    private func fullUrlFromTemplate(instance: T, _ uri: String) -> String {
        var result = uri;
        let ids = (instance as! MultiId).ids;
        for (key, id) in ids {
            let keyToken = String(format:"{%@}", key)
            result = result.stringByReplacingOccurrencesOfString(keyToken, withString: id);
        }
        return result;
    }
}
