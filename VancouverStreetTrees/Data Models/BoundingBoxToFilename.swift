//
//  BoundingBoxToFilename.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import UIKit
struct BoundingBoxToFilename:Hashable {
    let rect:CGRect
    let filename:String

    func hash(into hasher: inout Hasher) {
        hasher.combine(filename)
    }

    func load() -> [Feature] {
        let fileURL = Bundle.main.url(forResource: filename, withExtension: "")!
        let fileData = try! Data(contentsOf: fileURL)
        return try! JSONDecoder().decode([Feature].self, from: fileData)
    }
}
