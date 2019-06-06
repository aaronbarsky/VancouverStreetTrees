//
//  MapViewControllerTests.swift
//  VancouverStreetTreesTests
//
//  Created by Aaron Barsky on 6/5/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//
import XCTest
@testable import VancouverStreetTrees

class MapViewControllerTests: XCTestCase {

    var sut:MapViewController!
    var allTrees:[Feature]!

    override func setUp() {
        sut = MapViewController()
        allTrees = sut.loadTreeData()
        super.setUp()
    }
    
    func test_detailUrlForEachFeatureIsValid() {
        allTrees.forEach {
            let url = sut.detailURLFor(feature: $0)
            XCTAssertNotNil(url)
        }
    }

    func test_colorArrayCoversEveryGenus() {
        allTrees.forEach {
            let color = sut.genusToColor[$0.properties.genusName]
            XCTAssertNotNil(color)
        }
    }
}
