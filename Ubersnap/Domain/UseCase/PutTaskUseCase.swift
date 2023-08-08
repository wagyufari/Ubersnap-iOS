//
//  PutTaskUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import CoreData

class PutTaskUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke(title: String, description: String, dueDate: Date?, colorHex: String?) {
        let newItem = Task(context: managedObjectContext)
        newItem.timestamp = Date()
        newItem.id = UUID()
        newItem.title = title
        newItem.desc = description
        newItem.due_date = dueDate
        newItem.color = colorHex
        
        do {
            try managedObjectContext.save()
        } catch {
            
        }
    }
    
}
