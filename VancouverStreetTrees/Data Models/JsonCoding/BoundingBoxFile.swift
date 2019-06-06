//
//  BoundingBoxFile.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation

struct BoundingBoxFile:Codable {
    let minLat:Float
    let maxLat:Float
    let minLng:Float
    let maxLng:Float
    let filename:String

}
