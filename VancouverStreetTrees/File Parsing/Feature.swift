// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let feature = try? newJSONDecoder().decode(Feature.self, from: jsonData)

import Foundation

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let geometry: Geometry
    let properties: Properties

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case geometry = "geometry"
        case properties = "properties"
    }
}
