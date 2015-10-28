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

    func get<U>(instance: T, _ url: String) -> U {
        let template = urlTemplateFromFull(instance, url)
        return get(instance, self.urlTemplateToProperty[template] as! SimplePropertyMapping<T, U>);
    }

    func set<U>(instance: T, _ property: SimplePropertyMapping<T, U>, _ value: U) {
        property.set(instance, value: value);
    }
    
    func set<U>(instance: T, _ url: String, _ value: U) {
        let template = urlTemplateFromFull(instance, url)
        set(instance, self.urlTemplateToProperty[template] as! SimplePropertyMapping<T, U>, value);
    }

    /*
     * Convenience methods for managing collection properties
     */
    
    func get<U>(instance: T, _ property: CollectionPropertyMapping<T, U>) -> MutableFirebaseCollection<U> {
        return property.get(instance);
    }

    func addChild<U>(instance: T, _ property: CollectionPropertyMapping<T, U>, _ child: U) {
        property.addChild(instance, child: child);
    }

    func addChild(instance: T, _ url: String, _ child: [String: String]) {
        let template = urlTemplateFromFull(instance, url)
        let property = self.urlTemplateToProperty[template]!
        let v = property as! CollectionPropertyMapping<T, CollectionItem>
        v.addChild(instance, child: v.codec.decode(child))
    }

    func addChild<U>(instance: T, _ property: PropertyMapping<T>, _ child: [String: String], type: U.Type) {

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

    private func castCollection<U>(p: PropertyMapping<T>, type: U.Type) -> CollectionPropertyMapping<T, U> {

        return p as! CollectionPropertyMapping<T, U>
    }
}
