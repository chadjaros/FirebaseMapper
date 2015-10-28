//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation
import Firebase

protocol TestModelDelegate {
    var didTestModelUpdateColor: ((TestModel) -> Void)? { get }
    var didTestModelUpdateSize: ((TestModel) -> Void)? { get }
    var didTestModelAddLine: ((TestModel) -> Void)? { get }
    var didTestModelRemoveLine: ((TestModel) -> Void)? { get }
    var didTestModelUpdateLine: ((TestModel) -> Void)? { get }
}

class TestModel: Mappable<TestModel> {

    static let colorProperty = PropertyMapping<TestModel, String>(
            "/color",
            { return $0.delegate.didTestModelUpdateColor != nil },
            { return $0.color },
            {
                $0.color = $1
                if let callback = $0.delegate.didTestModelUpdateColor {
                    callback($0)
                }
            }
    )
    static let sizeProperty = PropertyMapping<TestModel, Double>(
            "/size",
            { return $0.delegate.didTestModelUpdateSize != nil },
            { return $0.size },
            {
                $0.size = $1
                if let callback = $0.delegate.didTestModelUpdateSize {
                    callback($0)
                }
            }
    )
    static let linesProperty = CollectionPropertyMapping<TestModel, Line>(
            "/lines",
            { return
                $0.delegate.didTestModelAddLine != nil ||
                $0.delegate.didTestModelRemoveLine != nil ||
                $0.delegate.didTestModelUpdateLine != nil
            },
            { return $0.lines }
    )
    static let modelMap = ModelMapping<TestModel>(
        firebaseUri: "http://my.firebase.com/testModel/{id}",
        properties: [
            colorProperty,
            sizeProperty,
            linesProperty
        ]
    )
    override class func modelMapping() -> ModelMapping<TestModel> {
        return modelMap
    }

    private let delegate: TestModelDelegate
    private var firebase: FirebaseConnection<TestModel>!

    private(set) var color: String
    private(set) var size: Double
    private var lines: MutableFirebaseCollection<Line>

    init(id: String, delegate: TestModelDelegate) {
        self.delegate = delegate
        self.color = ""
        self.size = 0.0
        self.lines = MutableFirebaseCollection<Line>()
        self.firebase = nil
        super.init(id:id)
        self.firebase = FirebaseConnection(self)
    }

    func start() {
        self.firebase.start()
    }

    func stop() {
        self.firebase.stop()
    }

    func updateColor(value: String) {
        firebase.updateValue(TestModel.colorProperty, value)
    }

    func updateSize(value: Double) {
        firebase.updateValue(TestModel.sizeProperty, value)
    }


}
