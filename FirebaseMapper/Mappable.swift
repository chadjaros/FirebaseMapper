//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

protocol IDable {
    var id: String { get }
    var ids: [String] { get }
}

class Mappable<T>: IDable {

    class func modelMapping() -> ModelMapping<T>!  {
        return nil
    }
    
    let ids: [String]
    
    init(ids: [String]) {
        self.ids = ids;
    }
    
    init(id: String) {
        self.ids = [id];
    }
    
    var id:String {
        get {
            return ids[0];
        }
    }
}