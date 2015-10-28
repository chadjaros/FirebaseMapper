//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class BasePropertyMapping<T>: NSObject {

    typealias ConnectIndicator = (T) -> Bool

    let firebaseUri:String;
    let connectIndicator: ConnectIndicator

    init(_ firebaseUri: String, _ connectIndicator: ConnectIndicator) {
        self.firebaseUri = firebaseUri
        self.connectIndicator = connectIndicator
    }
}