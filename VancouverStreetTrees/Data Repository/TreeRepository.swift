//
//  TreeRepository.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import CoreGraphics
class TreeRepository {
    var unloadedRegions:Set<BoundingBoxToFilename>
    init () {
        let regionMapURL = Bundle.main.url(forResource: "BoundingBoxToFile", withExtension: "json")!
        let regionMapData = try! Data(contentsOf: regionMapURL)
        let regionMap = try! JSONDecoder().decode([BoundingBoxFile].self, from: regionMapData)
        let allRegions:[BoundingBoxToFilename] = regionMap.map {
            let cgRect = CGRect(x: CGFloat($0.minLng),
                                y: CGFloat($0.minLat),
                                width: CGFloat($0.maxLng - $0.minLng),
                                height: CGFloat($0.maxLat - $0.minLat) )
            return BoundingBoxToFilename(rect: cgRect, filename: $0.filename)
        }
        unloadedRegions = Set(allRegions)
    }

    func unloadedAnnotationsFor(boundingBox:CGRect) -> [TreeAnnotation] {
        var annotations:[TreeAnnotation] = []
        for region in unloadedRegions{
            if region.rect.intersects(boundingBox) {
                print ("Loading \(region.filename)")
                unloadedRegions.remove(region)
                let regionTrees = region.load()
                let treeAnnotations = regionTrees.map { TreeAnnotation(feature: $0) }
                annotations += treeAnnotations
            }
        }
        return annotations
    }

}
