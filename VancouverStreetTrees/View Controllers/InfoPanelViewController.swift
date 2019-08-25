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
	@IBOutlet weak var swipeIndicator: UIView!
	
	var treeAnnotation:TreeAnnotation?
	var swipedToDismiss:(() -> ())?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		swipeIndicator.layer.cornerRadius = 4
	}
	
	let defaultDatePlanted = "26-Jan-2019"
	func bindTo(treeAnnotation:TreeAnnotation) {
		self.treeAnnotation = treeAnnotation
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MMM-yyyy"
		let tree = treeAnnotation.tree
		commonNameLabel.text = tree.commonName
		latinNameLabel.text = "\(tree.genusName!) \(tree.speciesName!) \(tree.cultivarName ?? "")"
		if let datePlanted = tree.datePlanted,
			dateFormatter.string(from: datePlanted) != defaultDatePlanted {
			datePlantedLabel.text = "Planted: \(dateFormatter.string(from: datePlanted))"
			datePlantedLabel.isHidden = false
		} else {
			datePlantedLabel.isHidden = true
		}
		let filename = "\(tree.genusName!.uppercased())\(tree.speciesName!.uppercased())"
		if let thumbnail = UIImage(named:filename) {
			image.image = thumbnail
		}
	}
	
	@IBAction func swiped(_ sender: Any) {
		swipedToDismiss?()
	}
	
	@IBAction func tapped(_ sender: Any) {
		guard let treeAnnotation = treeAnnotation else {
			return
		}
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let wikipediaVC = storyboard.instantiateViewController(withIdentifier: "WikipediaVC") as! WikipediaViewController
		_ = wikipediaVC.view
		let url = treeAnnotation.detailURL()
		let urlRequest = URLRequest(url: url)
		wikipediaVC.webView.load(urlRequest)
		navigationController?.pushViewController(wikipediaVC, animated: true)
		
	}
}
