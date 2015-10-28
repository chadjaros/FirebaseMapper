//
// Created by Chad Jaros on 10/27/15.
// Copyright (c) 2015 Classkick. All rights reserved.
//

import Foundation
import Firebase

protocol TestModelDelegate {
    var didTestModelUpdateColor: ((TestModel) -> Void)? { get }
    var didTestModelUpdateSize: ((TestModel) -> Void)? { get }
    var didTestModelAddLine: ((TestModel, Line) -> Void)? { get }
    var didTestModelRemoveLine: ((TestModel, Line) -> Void)? { get }
    var didTestModelUpdateLine: ((TestModel, Line) -> Void)? { get }
}

class TestModel: FirebaseMappable<TestModel> {

    static let colorProperty = SimplePropertyMapping<TestModel, String>(
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
    static let sizeProperty = SimplePropertyMapping<TestModel, Double>(
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
            uri: "/lines",
            connectIndicator: { return
                $0.delegate.didTestModelAddLine != nil ||
                $0.delegate.didTestModelRemoveLine != nil ||
                $0.delegate.didTestModelUpdateLine != nil
            },
            getter: { return $0.lines },
            didAdd: { 
                if let callback = $0.delegate.didTestModelAddLine {
                    callback($0, $1)
                }
            },
            didRemove: { 
                if let callback = $0.delegate.didTestModelRemoveLine {
                    callback($0, $1)
                }
            },
            didChange: {
                if let callback = $0.delegate.didTestModelUpdateLine {
                    callback($0, $1)
                }
            }
    )
    static let modelMap = ModelMapping<TestModel>(
        uri: "http://my.firebase.com/testModel/{id}",
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

    private(set) var color: String
    private(set) var size: Double
    private var _lines: MutableFirebaseCollection<Line>

    init(id: String, delegate: TestModelDelegate) {
        self.delegate = delegate
        self.color = ""
        self.size = 0.0
        self._lines = MutableFirebaseCollection<Line>()
        super.init(id)
    }

    func updateColor(value: String) {
        firebase.updateValue(TestModel.colorProperty, value)
    }

    func updateSize(value: Double) {
        firebase.updateValue(TestModel.sizeProperty, value)
    }

    var lines: FirebaseCollection<Line> {
        get {
            return self._lines
        }
    }

    func createLine(line: Line) -> Line {
        return firebase.createChild(TestModel.linesProperty, line)
    }

    func updateLine(line: Line) {
        firebase.upsertChild(TestModel.linesProperty, line)
    }

    func removeLine(line: Line) {
        firebase.removeChild(TestModel.linesProperty, line)
    }

}
