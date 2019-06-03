// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let streetTrees = try? newJSONDecoder().decode(StreetTrees.self, from: jsonData)

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
