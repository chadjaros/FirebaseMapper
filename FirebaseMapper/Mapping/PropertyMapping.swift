//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class PropertyMapping<T>: NSObject {

    typealias ConnectIndicator = (T) -> Bool

    let uri: String;
    let connectIndicator: ConnectIndicator
    var isCollection: Bool {
        get {
            return false
        }
    }

    init(_ uri: String, _ connectIndicator: ConnectIndicator) {
        self.uri = uri
        self.connectIndicator = connectIndicator
    }
}