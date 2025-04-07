//
//  Task+CoreDataProperties.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-04-06.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var subtasks: NSSet?

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Subtask)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Subtask)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

extension Task : Identifiable {

}
