//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation
import Firebase

// This should use a generic constraint T: Mappable<T>, but that throws a compile error
class FirebaseConnection<T> {

    private let instance: T
    private let mapping: ModelMapping<T>
    private var firebases: [String: Firebase]

    convenience init(_ instance: T) {
        self.init(instance, instance as! ModelMapping<T>)
    }

    init(_ instance: T, _ mapping: ModelMapping<T>) {
        self.firebases = [String: Firebase]()
        self.mapping = mapping
        self.instance = instance
    }

    func start() {
        for (_, property) in mapping.urlTemplateToProperty {
            if(property.connectIndicator(self.instance)) {
                let url = self.mapping.fullUrlForProperty(self.instance, property)
                let propertyFirebase = FirebaseConnectionService.provider.createFirebase(url)
                firebases[url] = propertyFirebase
                if (property.isCollection) {
                    propertyFirebase.observeEventType(.ChildAdded, withBlock: didAddChild)
                    propertyFirebase.observeEventType(.ChildRemoved, withBlock: didRemoveChild)
                    propertyFirebase.observeEventType(.ChildChanged, withBlock: didUpdateChild)
                }
                else {
                    propertyFirebase.observeEventType(.Value, withBlock: didUpdateValue)
                }
            }
        }
    }
    
    func stop() {
        for (_, firebase) in self.firebases {
            firebase.removeAllObservers()
        }
    }

    private func didUpdateValue(data: FDataSnapshot!)  {
        let firebaseUrl = data.ref.description
        let property = self.mapping.propertyForFullUrl(self.instance, firebaseUrl) as! SimplePropertyMapping<T, AnyObject>
        self.mapping.set(self.instance, property, property.codec.decode(FirebaseValue(data.value)))
    }

    func updateValue<U>(property: SimplePropertyMapping<T, U>, _ value: U) {
        let firebase = firebases[self.mapping.fullUrlForProperty(self.instance, property)]
        firebase?.setValue(property.codec.encode(value).value)
    }

    private func didAddChild(data: FDataSnapshot!)  {
        let firebaseUrl = data.ref.description
        let property = self.mapping.propertyForFullUrl(self.instance, firebaseUrl) as! CollectionPropertyMapping<T, CollectionItem>
        self.mapping.addChild(instance, property, property.codec.decode(FirebaseValue(data.value)))
    }

    func createChild<U>(property: CollectionPropertyMapping<T, U>, value: U) {
        let firebase = firebases[self.mapping.fullUrlForProperty(self.instance, property)]
        let childFirebase = firebase!.childByAutoId()
        let value = U(id: childFirebase.key, copy: value)
        childFirebase.setValue(property.codec.encode(value).value)
    }

    private func didRemoveChild(data: FDataSnapshot!)  {
        let firebaseUrl = data.ref.description
        let property = self.mapping.propertyForFullUrl(self.instance, firebaseUrl) as! CollectionPropertyMapping<T, CollectionItem>
        self.mapping.removeChild(instance, property, property.codec.decode(FirebaseValue(data.value)))
    }

    func removeChild<U>(property: CollectionPropertyMapping<T, U>, _ value: U) {
        let firebase = firebases[self.mapping.fullUrlForProperty(self.instance, property)]
        let childFirebase = firebase?.childByAppendingPath(value.id)
        childFirebase?.removeValue()
    }

    private func didUpdateChild(data: FDataSnapshot!)  {
        let firebaseUrl = data.ref.description
        let property = self.mapping.propertyForFullUrl(self.instance, firebaseUrl) as! CollectionPropertyMapping<T, CollectionItem>
        self.mapping.updateChild(instance, property, property.codec.decode(FirebaseValue(data.value)))
    }

    func upsertChild<U>(property: CollectionPropertyMapping<T, U>, _ value: U) {
        let firebase = firebases[self.mapping.fullUrlForProperty(self.instance, property)]
        let childFirebase = firebase?.childByAppendingPath(value.id)
        childFirebase?.setValue(property.codec.encode(value).value)
    }
}
