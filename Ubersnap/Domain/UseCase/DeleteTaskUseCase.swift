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
    
    func invoke(id: UUID?, onSuccess: (()->Void)? = nil, onFailed: ((String)->Void)? = nil) {
        do {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let items = try managedObjectContext.fetch(fetchRequest).filter { todo in
                todo.id == id
            }
            if items.isEmpty {
                onFailed?("Task not found")
            } else {
                items.forEach(managedObjectContext.delete)
                try managedObjectContext.save()
                onSuccess?()
            }
        } catch {
            onFailed?(error.localizedDescription)
        }
    }
    
}
