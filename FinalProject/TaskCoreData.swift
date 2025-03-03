//
//  TaskCoreData.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-03-02.
//

import Foundation
import CoreData

@objc(TaskCoreData)
public class TaskCoreData: NSManagedObject {
    
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
}
