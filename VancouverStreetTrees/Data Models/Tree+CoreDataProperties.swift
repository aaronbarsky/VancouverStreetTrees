//
//  Tree+CoreDataProperties.swift
//  TreeImport
//
//  Created by Aaron Barsky on 2019-07-21.
//  Copyright © 2019 Aaron Barsky. All rights reserved.
//
//

import Foundation
import CoreData


extension Tree {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tree> {
        return NSFetchRequest<Tree>(entityName: "Tree")
    }

    @NSManaged public var commonName: String?
    @NSManaged public var cultivarName: String?
    @NSManaged public var datePlanted: NSDate?
    @NSManaged public var diameter: Float
    @NSManaged public var genusName: String?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var speciesName: String?
    @NSManaged public var treeId: Int32

}
