//
//  StreetTrees.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation

// MARK: - StreetTrees
struct StreetTrees: Codable {
    let type: String
    let name: String
    let features: [Feature]

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case name = "name"
        case features = "features"
    }
}
