//
//  NSManagedObject+Extensions.swift
//  BLMusic
//
//  Created by Son Hoang on 17/10/2022.
//

import CoreData

public extension NSManagedObject {
    convenience init(testContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: testContext)!
        self.init(entity: entity, insertInto: testContext)
    }
}
