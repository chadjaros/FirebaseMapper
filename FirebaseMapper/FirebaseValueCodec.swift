//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class FirebaseValueCodec<T>: Codec<T, FirebaseValue> {

}

class DefaultFirebaseValueCodec<T>: FirebaseValueCodec<T> {
    override func encode(toEncode: T) -> FirebaseValue {
        return FirebaseValue(toEncode as! AnyObject)
    }

    override func decode(toDecode: FirebaseValue) -> T {
        return toDecode.value as! T
    }
}