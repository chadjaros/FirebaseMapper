//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

final class Line: CollectionItem {

    let id: String
    let color: String

    init(id: String, color: String) {
        self.id = id
        self.color = color
    }

    init(id: String, copy: Line? = nil) {
        self.id = id
        self.color = copy?.color ?? ""
    }

}
