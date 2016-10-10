//
//  Favorites+CoreDataProperties.swift
//  IGDBGameApp
//
//  Created by Stannis Baratheon on 10/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites");
    }

    @NSManaged public var gameId: Int64
    @NSManaged public var isActive: Bool

}
