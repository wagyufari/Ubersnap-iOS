//
//  ToggleTaskUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation
import CoreData

class ToggleTaskUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke(task: Task){
        do {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let tasks = try managedObjectContext.fetch(fetchRequest)
            
            if let task = tasks.first(where: { $0.id == task.id }) {
                if TaskState(rawValue: task.state ?? "") == .Completed {
                    task.state = TaskState.Running.rawValue
                } else {
                    task.state = TaskState.Completed.rawValue
                }
                try managedObjectContext.save()
            }
        } catch {
            // Handle error
        }
    }
    
    
    
}
