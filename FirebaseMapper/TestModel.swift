//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation

class TestModel: Mappable<TestModel> {

    static let colorProperty = PropertyMapping<TestModel, String>(
            "/color",
            { return $0.color },
            { $0.color = $1 }
    )
    static let sizeProperty = PropertyMapping<TestModel, Double>(
            "/size",
            { return $0.size },
            { $0.size = $1 }
    )
    static let countProperty = PropertyMapping<TestModel, Int>(
            "/count",
            { return $0.count },
            { $0.count = $1 }
    )
    override class func classMap() -> ModelMapping<TestModel> {

        return ModelMapping<TestModel>(
            firebaseUri: "http://my.firebase.com/testModel/{id}",
            properties: [
                colorProperty,
                sizeProperty,
                countProperty
            ]
        )
    }

    private(set) var color: String
    private(set) var size: Double
    private(set) var count: Int

    init(id: String, color: String, size: Double, count: Int) {
        self.color = color
        self.size = size
        self.count = count
        super.init(id:id)
    }

    
}
