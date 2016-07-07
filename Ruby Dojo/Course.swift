//
//  Course.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/7/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class Course: NSManagedObject {
    
    // MARK: Core Data Attributes
    @NSManaged var id: Int
    @NSManaged var descriptionText: String
    @NSManaged var title: String
    @NSManaged var iconName: String
    
    var icon: UIImage? {
        return UIImage(named: iconName)
    }
    
    // MARK: Standard Core Data Init Method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // MARK: Two Argument Init Method
    init(id: Int, descriptionText: String, title: String, iconName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.descriptionText = descriptionText
        self.title = title
        self.iconName = iconName
    }
}
