//
//  Subtask+CoreDataProperties.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-03-16.
//
//

import Foundation
import CoreData


extension Subtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var parentTask: Task?

}

extension Subtask : Identifiable {

}
