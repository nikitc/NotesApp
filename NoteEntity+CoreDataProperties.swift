//
//  NoteEntity+CoreDataProperties.swift
//  
//
//  Created by Admin on 21.04.18.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var importance: String?
    @NSManaged public var color: String?
    @NSManaged public var uuid: String?

}
