//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by A664291 on 5/31/17.
//  Copyright © 2017 Tyler Poland. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
