//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

protocol SingleId {
    var id: String { get }
}

protocol MultiId: SingleId {
    var ids: [String: String] { get }
}

class Mappable<T>: MultiId {



    class func modelMapping() -> ModelMapping<T>!  {
        return nil
    }
    
    private let _ids: [String: String]
    
    init(id: String) {
        self._ids = ["id": id];
    }
    
    init(id: String, var extraIds: [String: String]) {
        extraIds["id"] = id;
        self._ids = extraIds;
    }

    var id: String {
        get {
            return self._ids["id"]!
        }
    }

    var ids: [String: String] {
        get {
            return self._ids
        }
    }
}