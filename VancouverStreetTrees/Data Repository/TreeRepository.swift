//
//  TreeRepository.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/6/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import CoreData

class TreeRepository {
	
	var loadedTreeIds:Set<Int32> = []
	
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "TreeImport")
		container.loadPersistentStoresWithPreload() { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
    init () {
		
    }
	
	func unloadedAnnotationsFor(mapRectBoundingBox:MapRectBoundingBox)->[TreeAnnotation] {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tree")
		fetchRequest.predicate = NSPredicate(format: """
			latitude >= \(mapRectBoundingBox.min.latitude) AND
			latitude <= \(mapRectBoundingBox.max.latitude) AND
			longitude >= \(mapRectBoundingBox.min.longitude) AND
			longitude <= \(mapRectBoundingBox.max.longitude)
			"""
		)
		let trees = try! persistentContainer.viewContext.fetch(fetchRequest) as! [Tree]
		
		let newTrees = trees.filter{!loadedTreeIds.contains($0.treeId)}
		let newTreeIds = newTrees.map {$0.treeId}
		loadedTreeIds.formUnion(Set(newTreeIds))
		return newTrees.map {TreeAnnotation(tree: $0)}
	}
	
	func allTrees() -> [TreeAnnotation] {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tree")
		let trees = try! persistentContainer.viewContext.fetch(fetchRequest) as! [Tree]		
		return trees.map {TreeAnnotation(tree: $0)}
		
	}
}
