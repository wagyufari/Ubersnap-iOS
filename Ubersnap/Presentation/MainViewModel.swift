//
//  MainViewModel.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import SwiftUI
import CoreData

class MainViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var items: [Task] = []
    private var useCase: TaskUseCases
    
    private var fetchedResultsController: NSFetchedResultsController<Task>?

    init(useCase: TaskUseCases) {
        self.useCase = useCase
    }

    func getTask() {
        let fetchedResultsController = useCase.get.invoke()
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController

        do {
            try fetchedResultsController.performFetch()
            items = fetchedResultsController.fetchedObjects ?? []
            print(items)
        } catch {
            items = []
        }
    }
    
    func toggleTask(task: Task) {
        withAnimation {
            useCase.toggle.invoke(task: task)
        }
    }
}

extension MainViewModel {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedItems = controller.fetchedObjects as? [Task] {
            items = fetchedItems
        }
    }
}

