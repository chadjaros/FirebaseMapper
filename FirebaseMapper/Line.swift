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

class LineCodec: DictionaryCodec<Line> {

    override func encode(toEncode: Line) -> [String: String] {
        return [
            "id": toEncode.id,
            "color": toEncode.color
        ]
    }
    
    override func decode(toDecode: [String: String]) -> Line {
        return Line(
            id: toDecode["id"] ?? "",
            color: toDecode["color"] ?? ""
        )
    }
    
}