//
//  TaskCoreData.swift
//  FinalProject
//

import Foundation
import CoreData

@objc(TaskCoreData)
public class TaskCoreData: NSManagedObject {
    
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
}
