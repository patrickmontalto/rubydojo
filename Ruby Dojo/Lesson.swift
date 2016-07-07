//
//  Lesson.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/7/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit
import CoreData

class Lesson: NSManagedObject {
    
    // MARK: Core Data Attributes
    @NSManaged var id: Int
    @NSManaged var isCompleted: Bool
    @NSManaged var menuItemsString: String?
    @NSManaged var text: String
    @NSManaged var title: String
    
    var menuItemActions: [String]? {
        /* GUARD: Are there any menu items? */
        guard menuItemsString != nil else {
            return nil
        }
        
        /* GUARD: Can we split the menu items into an array of strings? */
        guard let menuItemsArray = menuItemsString?.componentsSeparatedByString(",") else {
            return nil
        }
        
        return menuItemsArray
    }
    
    // MARK: Standard Core Data Init Method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // MARK: Two Argument Init
    init(id: Int, isCompleted: Bool, menuItemsString: String?, text: String, title: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Lesson", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.isCompleted = isCompleted
        self.menuItemsString = menuItemsString
        self.text = text
        self.title = title
    }
    
    
}
