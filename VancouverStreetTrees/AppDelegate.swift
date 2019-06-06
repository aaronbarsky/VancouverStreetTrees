//
//  AppDelegate.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/2/19.
//  Copyright © 2019 YellowCedarSoftware. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


/*
        var regions:[BoundingBoxFile] = []
        let regionNames = ["ArbutusRidge",
                           "Downtown",
                            "DunbarSouthlands",
        "Fairview",
        "GrandviewWoodland",
        "HastingsSunrise",
        "KensingtonCedarCottage",
        "Kerrisdale",
        "Killarney",
        "Kitsilano",
        "Marpole",
        "MountPleasant",
        "Oakridge",
        "RenfrewCollingwood",
        "RileyPark",
        "Shaughnessy",
        "SouthCambie",
        "Strathcona",
        "Sunset",
        "VictoriaFraserview",
        "WestEnd",
        "WestPointGrey"]
        for regionName in regionNames {
            let treeDataJsonFileURL = Bundle.main.url(forResource: "StreetTrees_\(regionName)", withExtension: "json")!
            let treeData = try! Data(contentsOf: treeDataJsonFileURL)
            let trees  = try! JSONDecoder().decode(StreetTrees.self, from: treeData)
            let latitudes = trees.features.map {$0.geometry.coordinates[1]}
            let longitudes = trees.features.map {$0.geometry.coordinates[0]}

            let rect = BoundingBoxFile(minLat: latitudes.min()!,
                            maxLat: latitudes.max()!,
                            minLng: longitudes.min()!,
                            maxLng: longitudes.max()!,
                            filename: "Trees_\(regionName).json")
            regions += [rect]

            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,  true).first!
            let outputFile = NSURL(fileURLWithPath: rect.filename, relativeTo: NSURL(fileURLWithPath: documentsDirectory, isDirectory: true) as URL)
            print ("\(outputFile)")
            let treesData = try! JSONEncoder().encode(trees.features)
            try! treesData.write(to: outputFile as URL)
        }

        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,  true).first!
        let outputFile = NSURL(fileURLWithPath: "BoundingBoxToFile.json", relativeTo: NSURL(fileURLWithPath: documentsDirectory, isDirectory: true) as URL)
        print ("\(outputFile)")
        let bbData = try! JSONEncoder().encode(regions)
        try! bbData.write(to: outputFile as URL)

        */

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

