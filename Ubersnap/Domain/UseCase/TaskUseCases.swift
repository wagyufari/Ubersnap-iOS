//
//  TaskUseCases.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import CoreData

class TaskUseCases {
    
    var put: PutTaskUseCase
    var delete: DeleteTaskUseCase
    var get: GetTaskUseCase
    var update: UpdateTaskUseCase
    
    init(managedObjectContext: NSManagedObjectContext) {
        put = PutTaskUseCase(managedObjectContext: managedObjectContext)
        delete = DeleteTaskUseCase(managedObjectContext: managedObjectContext)
        get = GetTaskUseCase(managedObjectContext: managedObjectContext)
        update = UpdateTaskUseCase(managedObjectContext: managedObjectContext)
    }
    
}
