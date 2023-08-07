//
//  DeleteTaskUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import CoreData

class DeleteTaskUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke(id: UUID?) {
        do {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let items = try managedObjectContext.fetch(fetchRequest)
            items.filter { todo in
                todo.id == id
            }.forEach(managedObjectContext.delete)
            try managedObjectContext.save()
        } catch {
            
        }
    }
    
}
