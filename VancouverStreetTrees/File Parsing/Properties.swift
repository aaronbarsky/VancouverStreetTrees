// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let properties = try? newJSONDecoder().decode(Properties.self, from: jsonData)

import Foundation

// MARK: - Properties
struct Properties: Codable {
    let treeID: Int
//    let civicNumber: Int
//    let stdStreet: String
//    let neighbourhoodName: String
//    let onStreet: String
//    let onStreetBlock: Int
//    let streetSideName: String
//    let assigned: String
//    let heightRangeID: Int
    let diameter: Float
    let datePlanted: String
//    let plantArea: String?
//    let rootBarrier: String
//    let curb: String
    let cultivarName: String
    let genusName: String
    let speciesName: String
    let commonName: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case treeID = "TREE_ID"
//        case civicNumber = "CIVIC_NUMBER"
//        case stdStreet = "STD_STREET"
//        case neighbourhoodName = "NEIGHBOURHOOD_NAME"
//        case onStreet = "ON_STREET"
//        case onStreetBlock = "ON_STREET_BLOCK"
//        case streetSideName = "STREET_SIDE_NAME"
//        case assigned = "ASSIGNED"
//        case heightRangeID = "HEIGHT_RANGE_ID"
        case diameter = "DIAMETER"
        case datePlanted = "DATE_PLANTED"
//        case plantArea = "PLANT_AREA"
//        case rootBarrier = "ROOT_BARRIER"
//        case curb = "CURB"
        case cultivarName = "CULTIVAR_NAME"
        case genusName = "GENUS_NAME"
        case speciesName = "SPECIES_NAME"
        case commonName = "COMMON_NAME"
        case latitude = "LATITUDE"
        case longitude = "LONGITUDE"
    }
}
