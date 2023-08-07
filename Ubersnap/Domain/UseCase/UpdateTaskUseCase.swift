//
//  UpdateTaskUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import CoreData

class UpdateTaskUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke(editedTask: Task) {
        do {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let tasks = try managedObjectContext.fetch(fetchRequest)
            
            if let task = tasks.first(where: { $0.id == editedTask.id }) {
                task.title = editedTask.title
                task.desc = editedTask.desc
                task.due_date = editedTask.due_date
                try managedObjectContext.save()
            }
        } catch {
            // Handle error
        }
    }
}
