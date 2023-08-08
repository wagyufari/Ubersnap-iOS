//
//  GetTaskByIdUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation
import CoreData

class GetTaskByIdUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke(taskId: UUID?) -> NSFetchedResultsController<Task> {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let taskId {
            fetchRequest.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
        }
        
        
        let timestampSortDescriptor = NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)
        fetchRequest.sortDescriptors = [timestampSortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Handle the error here.
        }
        
        return fetchedResultsController
    }
}
