//
//  Game+CoreDataProperties.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 06/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Games");
    }

    @NSManaged public var gameId: Double
    @NSManaged public var name: String?
    @NSManaged public var alternativeName: String?
    @NSManaged public var rating: Float
    @NSManaged public var url: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var summary: String?
    @NSManaged public var hypes: Int64
    @NSManaged public var popularity: Double
    @NSManaged public var aggregatedRating: Double
    @NSManaged public var rating_count: Int64
    @NSManaged public var category: Int64
    @NSManaged public var firstReleaseDate: NSDate?
    @NSManaged public var pegi: Int64
    @NSManaged public var coverCloudinaryId: String?

}
