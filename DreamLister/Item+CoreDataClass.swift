//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by A664291 on 5/31/17.
//  Copyright © 2017 Tyler Poland. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
