//
//  Tree+CoreDataProperties.swift
//  TreeLogger
//
//  Created by user180294 on 12/7/20.
//  Copyright © 2020 Aport093. All rights reserved.
//
//

import Foundation
import CoreData


extension Tree {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tree> {
        return NSFetchRequest<Tree>(entityName: "Tree")
    }

    @NSManaged public var adult_height: String?
    @NSManaged public var plant_date: Date?
    @NSManaged public var ready: Bool
    @NSManaged public var ready_date: Date?
    @NSManaged public var species: String?
    @NSManaged public var img: Data?

}
