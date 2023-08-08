//
//  GetTaskUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import CoreData

class GetTaskUseCase {
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func invoke() -> NSFetchedResultsController<Task> {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // First, sort by the state in ascending order.
        let stateSortDescriptor = NSSortDescriptor(keyPath: \Task.state, ascending: false)
        
        // Then, sort by the timestamp in ascending order.
        let timestampSortDescriptor = NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)
        
        // Combine the sort descriptors into an array.
        fetchRequest.sortDescriptors = [stateSortDescriptor, timestampSortDescriptor]
        
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
