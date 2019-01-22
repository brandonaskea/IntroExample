//
//  DatabaseManager.swift
//  IntroExample
//
//  Created by Brandon Askea on 1/21/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class DatabaseManager: NSObject, DataSourceProtocol {
    
    static let instance = DatabaseManager()
    
    func getDatabaseWith(name: String) -> Database? {
        do {
            return try Database(name: name)
        } catch { return nil }
    }
    
    func storeData() {
        
        // Get JSON file path
        guard let path = Bundle.main.path(forResource: "bigbang", ofType: "json") else { return }
        
        do {
            
            // Convert File into JSON
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonSer = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            guard let json = jsonSer as? [String: AnyObject] else { return }
            
            // Parse
            parse(json)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func parse(_ json: [String: AnyObject]) {
        
        // Grab Episodes
        guard let embedded = json["_embedded"] as? [String: AnyObject],
        let episodes = embedded["episodes"] as? [[String: AnyObject]]
        else { return }
        
        // Parse Episodes
        for episode in episodes {
            
            let idKey = "id"
            let seasonKey = "season"
            let numberKey = "number"
            let nameKey = "name"
            let summaryKey = "summary"
            let imageDictKey = "image"
            let imageKey = "medium"
            
            guard let id = episode[idKey] as? Int,
            let season = episode[seasonKey] as? Int,
            let number = episode[numberKey] as? Int,
            let name = episode[nameKey] as? String,
            let summary = episode[summaryKey] as? String,
            let imageDict = episode[imageDictKey] as? [String: AnyObject],
            let image = imageDict[imageKey] as? String
            else { continue }
            
            let newTask = MutableDocument()
            .setInt(id, forKey: idKey)
            .setInt(season, forKey: seasonKey)
            .setInt(number, forKey: numberKey)
            .setString(name, forKey: nameKey)
            .setString(summary.removeHTMLTags(), forKey: summaryKey)
            .setString(image, forKey: imageDictKey)
            save(newTask)
        }
    }
    
    func save(_ document: MutableDocument) {
        
        guard let database = getDatabaseWith(name: "bigbang") else { return }
        
        // Store 
        do {
            try database.saveDocument(document)
        }
        catch let error { print(error.localizedDescription) }
    }

}
