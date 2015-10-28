//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class FirebaseValue {

    let value: AnyObject

    init(_ value: AnyObject) {
        self.value = value
    }

    var isNumber: Bool {
        get {
            return self.value is NSNumber
        }
    }

    var isArray: Bool {
        get {
            return self.value is NSArray
        }
    }

    var isDictionary: Bool {
        get {
            return self.value is NSDictionary
        }
    }

    var isString: Bool {
        get {
            return self.value is String
        }
    }
    
    var string: String {
        get {
            return String(self.value)
        }
    }

    var number: NSNumber {
        get {
            return self.value as! NSNumber
        }
    }

    var array: [AnyObject] {
        get {
            return self.value as! [AnyObject]
        }
    }

    var dictionary: SimpleDictionary {
        get {
            return self.value as! SimpleDictionary
        }
    }
}
