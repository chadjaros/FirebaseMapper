//
// Created by Chad Jaros on 10/28/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

final class Line: CollectionItem {

    let color: String

    init(id: String, color: String) {
        self.color = color
        super.init(id: id)
    }

    required init(id: String, copy: CollectionItem? = nil) {
        let cast = copy == nil ? nil : copy as! Line?
        self.color = cast?.color ?? ""
        super.init(id: id)
    }
}

class LineCodec: FirebaseValueCodec<Line> {

    override func encode(toEncode: Line) -> FirebaseValue {
        return FirebaseValue([
            "id": toEncode.id,
            "color": toEncode.color
        ])
    }
    
    override func decode(toDecode: FirebaseValue) -> Line {
        return Line(
            id: toDecode.dictionary["id"] as? String ?? "",
            color: toDecode.dictionary["color"] as? String ?? ""
        )
    }
    
}