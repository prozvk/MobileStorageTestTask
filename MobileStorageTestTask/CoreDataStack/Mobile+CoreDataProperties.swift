//
//  Mobile+CoreDataProperties.swift
//  MobileStorageTestTask
//
//  Created by MacPro on 05.09.2022.
//
//

import Foundation
import CoreData


extension Mobile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mobile> {
        return NSFetchRequest<Mobile>(entityName: "Mobile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imei: String?
    @NSManaged public var model: String?

}

extension Mobile {
    convenience init(imei: String, model: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.imei = imei
        self.model = model
    }
}

extension Mobile : Identifiable { }
