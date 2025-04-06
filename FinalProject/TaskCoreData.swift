//
//  TaskCoreData.swift
//  FinalProject
//  Diego Tsukayama 101472085
//  Illia Konik 101460488
//

import Foundation
import CoreData

@objc(TaskCoreData)
public class TaskCoreData: NSManagedObject {
    
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
}
