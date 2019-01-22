//
//  Episode.swift
//  IntroExample
//
//  Created by Brandon Askea on 1/21/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation
import CouchbaseLiteSwift

struct Episode: Codable {
    var imageURL: String
    var name: String
    var summary: String
    var id: Int
    var number: Int
    var season: Int
    
    static func createFrom(_ document: Document) -> Episode? {
        
        let imageKey = "image"
        let nameKey = "name"
        let summaryKey = "summary"
        let idKey = "id"
        let numberKey = "number"
        let seasonKey = "season"
        
        guard let image = document.string(forKey: imageKey),
        let name = document.string(forKey: nameKey),
        let summary = document.string(forKey: summaryKey)
        else { return nil }
        let id = document.int(forKey: idKey)
        let number = document.int(forKey: numberKey)
        let season = document.int(forKey: seasonKey)
        
        return Episode(imageURL: image, name: name, summary: summary, id: id, number: number, season: season)

    }
}
