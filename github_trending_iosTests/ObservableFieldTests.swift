//
//  ObservableFieldTests.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import XCTest
@testable import github_trending_ios 

class ObservableFieldTests: XCTest {

    func testFieldUpdatesCorrectly() {
        let field = ObservableField<String>(value: "Yarp")
        XCTAssertEqual("Yarp", field.value)

        var value: String = ""
        var count = 0

        field.observe { newValue in
            value = newValue
            count += 1
        }

        for index in 1...5 {
            field.value = String(index)
        }

        XCTAssertEqual("5", value)
        XCTAssertEqual("5", field.value)
        XCTAssertEqual(5, count)
    }
}
