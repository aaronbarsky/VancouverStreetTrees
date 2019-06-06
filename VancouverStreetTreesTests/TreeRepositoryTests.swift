//
//  TreeAnnotationTests.swift
//  VancouverStreetTreesTests
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import XCTest
@testable import VancouverStreetTrees
class TreeRepositoryTests:XCTestCase {
    let allTrees:[TreeAnnotation] = TreeRepository().unloadedAnnotationsFor(boundingBox: CGRect(x:-180, y: -90, width:360, height:180))
    override func setUp() {
    }

    func test_detailUrlForEachTreeIsValid() {
        allTrees.forEach {
            let url = $0.detailURL()
            XCTAssertNotNil(url)
        }
    }

    func test_genusColorIsAvailableForEachTree() {
        allTrees.forEach {
            let color =  $0.color()
            XCTAssertNotEqual(color, UIColor.black)

        }
    }
}
