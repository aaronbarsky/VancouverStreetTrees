//
//  InfoPanelViewController.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 2019-08-24.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import UIKit
class InfoPanelViewController:UIViewController {
	
	@IBOutlet weak var commonNameLabel: UILabel!
	@IBOutlet weak var latinNameLabel: UILabel!
	@IBOutlet weak var datePlantedLabel: UILabel!
	@IBOutlet weak var image: UIImageView!
	
	let defaultDatePlanted = "26-Jan-2019"
	func bindTo(treeAnnotation:TreeAnnotation) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy"
		let tree = treeAnnotation.tree
		commonNameLabel.text = tree.commonName
		latinNameLabel.text = "\(tree.genusName!) \(tree.speciesName!) \(tree.cultivarName ?? "")"
		if let datePlanted = tree.datePlanted,
			dateFormatter.string(from: datePlanted) != defaultDatePlanted {
			datePlantedLabel.text = "Date planted: \(dateFormatter.string(from: datePlanted))"
			datePlantedLabel.isHidden = false
		} else {
			datePlantedLabel.isHidden = true
		}
		let filename = "\(tree.genusName!.uppercased())\(tree.speciesName!.uppercased())"
		if let thumbnail = UIImage(named:filename) {
			image.image = thumbnail
		}
	}
}
